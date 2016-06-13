FROM php:5.6-apache

MAINTAINER Ivan Klimchuk <ivan@klimchuk.com> (@alroniks)

RUN a2enmod rewrite expires

# install required packages
RUN apt-get update && \
    apt-get install -y \
        libpng12-dev \
        libjpeg-dev \
        zip \
        unzip \
        sudo \
        git && \
    rm -rf /var/lib/apt/lists/* 

# install php extensions
RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr && \
    docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && \
    docker-php-ext-configure mysql --with-mysql=mysqlnd && \
    docker-php-ext-configure mysqli --with-mysqli=mysqlnd && \
    docker-php-ext-install pdo && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install mysqli && \
    docker-php-ext-install mysql && \
    docker-php-ext-install gd && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install opcache && \
    docker-php-ext-install zip

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

RUN git clone --progress --verbose https://github.com/oat-sa/package-tao.git -b fix/composer_dependencies .

# install composer
RUN curl -sS https://getcomposer.org/installer | php

# install dependencies
RUN php composer.phar config --global github-protocols https && \
    php composer.phar install --prefer-source -vvv

RUN chown -R www-data:www-data /var/www/html

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["apache2-foreground"]