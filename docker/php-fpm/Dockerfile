FROM php:8.2-fpm-bullseye

ARG PHALCON_VERSION=5.9.2

# Install system packages & PHP extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
    git unzip gnupg libzip-dev zip nano-tiny \
    libpng-dev libjpeg-dev libwebp-dev libfreetype6-dev \
    libicu-dev g++ libgmp-dev bash curl wget \
    libonig-dev libxml2-dev libssl-dev pkg-config \
    default-libmysqlclient-dev libcurl4-openssl-dev libgettextpo-dev && \
    docker-php-ext-configure intl && \
    docker-php-ext-configure gmp && \
    docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp && \
    docker-php-ext-install -j$(nproc) \
        gd mysqli pdo_mysql intl opcache exif zip gmp bcmath gettext && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pecl install apcu && \
    docker-php-ext-enable apcu && \
    echo "apc.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini

RUN pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    echo "xdebug.mode=develop,debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.start_with_request=trigger" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.discover_client_host=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install Phalcon extension
RUN set -xe && \
    cd / && \
    docker-php-source extract && \
    curl -sSLO https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz && \
    tar xzf /v${PHALCON_VERSION}.tar.gz && \
    docker-php-ext-install -j$(nproc) /cphalcon-${PHALCON_VERSION}/build/phalcon && \
    rm -rf \
        /v${PHALCON_VERSION}.tar.gz \
        /cphalcon-${PHALCON_VERSION} && \
    docker-php-source delete && \
    php -m

# PHP configuration (optional)
RUN echo "post_max_size = 150M" >> /usr/local/etc/php/conf.d/custom.ini && \
    echo "upload_max_filesize = 150M" >> /usr/local/etc/php/conf.d/custom.ini && \
    echo "memory_limit = 256M" >> /usr/local/etc/php/conf.d/custom.ini

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HOME=/usr/local/composer

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"

RUN alias xphp='export PHP_IDE_CONFIG="serverName=api.localhost"; XDEBUG_SESSION=PHPSTORM php -dxdebug.start_with_request=yes'

# Optional: copy scripts or setup entrypoint
COPY docker-phalcon-* /usr/local/bin/