FROM php:7.0-apache
MAINTAINER Alberto Roura <mail@albertoroura.com>

# Install base packages
RUN apt-get update -qq && apt-get install -y \
    locales -qq \
    && locale-gen en_AU \
    && locale-gen en_AU.UTF-8 \
    && dpkg-reconfigure locales \
    && locale-gen C.UTF-8 \
    && dpkg-reconfigure locales \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    && apt-get update && apt-get upgrade -y && apt-get install -y \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        python-software-properties \
        build-essential \
        xz-utils \
        libbz2-dev \
        libmemcached-dev \
        libmysqlclient-dev \
        libsasl2-dev \
        libxslt-dev \
        curl \
        git \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libmcrypt-dev \
        libmemcachedutil2 \
        libpng12-dev \
        libpq-dev \
        wget \
        unzip \
        zip \
        nano

# Install Project dependencies (PHP/Composer/Node/Grunt), then clean temporary files
RUN docker-php-ext-install bz2 calendar iconv intl xsl mbstring mcrypt mysqli opcache pdo_mysql pdo_pgsql pgsql zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && pecl install memcached redis \
    && docker-php-ext-enable memcached.so redis.so \
    && a2enmod rewrite \
    && echo "memory_limit=2048M" > /usr/local/etc/php/conf.d/memory-limit.ini \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && export PATH=$COMPOSER_HOME/vendor/bin:$PATH \
    && cd /tmp \
    && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get update && apt-get install -y nodejs \
    && npm install -g grunt-cli \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Clone Magento 2.1
RUN cd /var/www \
    && rm -rf html \
    && git clone -b 2.1 --single-branch --verbose https://github.com/magento/magento2.git html \
    && chsh -s /bin/bash www-data \
    && chown -R www-data:www-data /var/www \
    && su www-data -c "cd /var/www/html && composer install" \
    && cd /var/www/html \
    && chmod u+x bin/magento

# Script to automate magento setup:install
COPY ./install.sh /var/www/html/

# Script to automate a complete static files refresh
COPY ./publish-static.sh /var/www/html/

# Write proper permissions to scripts
RUN chmod u+x install.sh publish-static.sh
