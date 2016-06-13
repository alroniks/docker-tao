#!/bin/bash
set -e

if [[ "$1" == apache2* ]] || [ "$1" == php-fpm ]; then

    : "${TAO_DB_DRIVER:=pdo_mysql}"

    # TODO: add ability use postgres

    # MYSQL connection settings
    : "${TAO_DB_HOST:=mysql}"
    # if we're linked to MySQL and thus have credentials already, let's use them
    : ${TAO_DB_USER:=${MYSQL_ENV_MYSQL_USER:-root}}
    if [ "$TAO_DB_USER" = 'root' ]; then
        : ${TAO_DB_PASSWORD:=$MYSQL_ENV_MYSQL_ROOT_PASSWORD}
    fi
    : ${TAO_DB_PASSWORD:=$MYSQL_ENV_MYSQL_PASSWORD}
    : ${TAO_DB_NAME:=${MYSQL_ENV_MYSQL_DATABASE:-tao}}

    TERM=dumb php -- "$TAO_DB_HOST" "$TAO_DB_USER" "$TAO_DB_PASSWORD" "$TAO_DB_NAME" <<'EOPHP'
<?php
$stderr = fopen('php://stderr', 'w');
list($host, $port) = explode(':', $argv[1], 2);
$maxTries = 3;
do {
    $mysql = new mysqli($host, $argv[2], $argv[3], '', (int)$port);
    if ($mysql->connect_error) {
        fwrite($stderr, "\n" . 'MySQL Connection Error: (' . $mysql->connect_errno . ') ' . $mysql->connect_error . "\n");
        --$maxTries;
        if ($maxTries <= 0) {
            exit(1);
        }
        sleep(3);
    }
} while ($mysql->connect_error);
if (!$mysql->query('CREATE DATABASE IF NOT EXISTS `' . $mysql->real_escape_string($argv[4]) . '` ' .
    'DEFAULT CHARACTER SET = \'utf8mb4\' DEFAULT COLLATE \'utf8mb4_unicode_ci\'')) {
    fwrite($stderr, "\n" . 'MySQL "CREATE DATABASE" Error: ' . $mysql->error . "\n");
    $mysql->close();
    exit(1);
}
$mysql->close();
EOPHP

    # auto installation
    : ${TAO_AUTOINSTALL:=0}

    if [ "$TAO_AUTOINSTALL" = 1 ]; then

        # TAO application settings
        : ${TAO_MODULE_MODE:='production'}
        : ${TAO_USER_LOGIN:='admin'}
        : ${TAO_USER_PASSWORD:='admin'}
        : ${TAO_EXTENSIONS:='taoCe'}

        if [ -z "$TAO_MODULE_URL" ]; then
            echo >&2 'error: missing TAO_MODULE_URL environment variable'
            echo >&2 '  Set up correct url for this installation. Use ip and port or domain name.'
            echo >&2 '  Example: -e TAO_MODULE_URL=192.168.99.100:8080?'
            exit 1
        fi

        echo >&2 "Installing TAO..."
        sudo -u www-data php tao/scripts/taoInstall.php \
            --db_driver "$TAO_DB_DRIVER" \
            --db_host "$TAO_DB_HOST" \
            --db_name "$TAO_DB_NAME" \
            --db_user "$TAO_DB_USER" \
            --db_pass "$TAO_DB_PASSWORD" \
            --module_url "$TAO_MODULE_URL" \
            --module_mode "$TAO_MODULE_MODE" \
            --user_login "$TAO_USER_LOGIN" \
            --user_pass "$TAO_USER_PASSWORD" \
            -e "$TAO_EXTENSIONS" \
            --verbose
    fi
fi

exec "$@"