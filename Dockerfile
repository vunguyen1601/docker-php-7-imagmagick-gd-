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
    docker-php-ext-install pdo pdo_mysql mysqli intl; \
    docker-php-ext-configure intl gd \
            --prefix=/usr \
            --with-jpeg \
            --with-freetype;

RUN a2enmod rewrite;

EXPOSE 80
