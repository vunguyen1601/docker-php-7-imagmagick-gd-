FROM php:5.6-apache

MAINTAINER VuNT "nguyenthachvu.vn@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive
USER root

RUN echo "date.timezone=Asia/Tokyo" > /usr/local/etc/php/conf.d/timezone.ini

RUN sed -i -e 's/deb.debian.org/archive.debian.org/g' \
           -e 's|security.debian.org|archive.debian.org/|g' \
           -e '/stretch-updates/d' /etc/apt/sources.list

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
            --with-freetype \
            --enable-gd-native-ttf \
            --with-freetype-dir=/usr/include/freetype2 \
            --with-png-dir=/usr/include \
            --with-jpeg-dir=/usr/include \
            ; \
    docker-php-ext-install gd iconv mcrypt mbstring; \
    docker-php-ext-enable gd; \
    php -r 'var_dump(gd_info());'

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN a2enmod rewrite

RUN apt-get -qq update

RUN apt-get install -y net-tools

RUN apt-get install -y vim openssh-server supervisor
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN echo 'root:&%$!root!@' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

EXPOSE 22 80
VOLUME /var/www/html
ENV APACHE_RUN_USER root
ENV APACHE_RUN_GROUP root

ENTRYPOINT ["/usr/bin/supervisord"]