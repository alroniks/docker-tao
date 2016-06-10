FROM php:7.0-fpm

MAINTAINER Ivan Klimchuk <ivan@klimchuk.com> (@alroniks)

# install php extensions
RUN apt-get update && apt-get install -y -y libpng12-dev libjpeg-dev libpq-dev git \
        && rm -rf /var/lib/apt/lists/* \
        && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
        && docker-php-ext-install gd mbstring opcache pdo pdo_mysql pdo_pgsql zip

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=60'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

WORKDIR /var/www/html

RUN git clone --progress --verbose https://github.com/oat-sa/package-tao.git .

# install composer
RUN curl -sS https://getcomposer.org/installer | php

# install dependencies
RUN php composer.phar install

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["php-fpm"]