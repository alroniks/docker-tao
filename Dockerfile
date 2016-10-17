FROM php:7-fpm

MAINTAINER Ivan Klimchuk <ivan@klimchuk.com> (@alroniks)

RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev zip unzip sudo wget

RUN rm -rf /var/lib/apt/lists/* 

RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr
RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd
RUN docker-php-ext-configure mysqli --with-mysqli=mysqlnd

RUN docker-php-ext-install pdo && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install mysqli && \
    docker-php-ext-install gd && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install opcache && \
    docker-php-ext-install zip

RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=60'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
        echo 'opcache.load_comments=1'; \
    } > /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

VOLUME /var/www/html

ENV TAO_VERSION 3.1.0-RC3_build
ENV TAO_SHA1 270feb2d0fe4be4278d28c0954ff08ea53d828ed

RUN curl -o tao.zip -SL http://releases.taotesting.com/TAO_${TAO_VERSION}.zip \
  && echo "$TAO_SHA1 *tao.zip" | sha1sum -c - \
  && unzip -qq tao.zip -d /usr/src \
  && mv /usr/src/TAO_${TAO_VERSION} /usr/src/tao \
  && rm tao.zip \
  && chown -R www-data:www-data /usr/src/tao

RUN groupmod -g 1000 www-data
RUN usermod -u 1000 www-data
RUN usermod -g staff www-data

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["php-fpm"]