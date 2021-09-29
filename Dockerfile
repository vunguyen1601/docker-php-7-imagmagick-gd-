FROM php:7.4-apache

MAINTAINER VuNT "nguyenthachvu.vn@gmail.com"

RUN set -eux; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y --no-install-recommends \
            curl \
            libmemcached-dev \
            libz-dev \
            libpq-dev \
            libjpeg-dev \
            libpng-dev \
            libfreetype6-dev \
            libssl-dev \
            libmcrypt-dev \
            imagemagick \
            libmagickwand-dev \
            libonig-dev; \
    rm -rf /var/lib/apt/lists/*

RUN pecl install imagick && docker-php-ext-enable imagick

RUN set -eux; \
    docker-php-ext-install pdo pdo_mysql mysqli; \
    docker-php-ext-configure gd \
            --prefix=/usr \
            --with-jpeg \
            --with-freetype;
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl            

RUN echo "expose_php = Off\n" \
#         "memory_limit = 500M\n" \
#         "upload_max_filesize = 100M\n" \
#         "post_max_size = 100M\n" \
#         "max_execution_time = 600\n" \
         > /usr/local/etc/php/conf.d/configurations.ini

RUN a2enmod rewrite;


EXPOSE 80
