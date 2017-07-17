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

# Install PHP extensions.
RUN docker-php-ext-install bz2 calendar iconv intl xsl mbstring mcrypt mysqli opcache pdo_mysql pdo_pgsql pgsql zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && pecl install memcached redis \
    && docker-php-ext-enable memcached.so redis.so \
    && a2enmod rewrite \
    && echo "memory_limit=2048M" > /usr/local/etc/php/conf.d/memory-limit.ini

# Install Composer.
ENV COMPOSER_HOME /root/composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH

RUN rm -rf /var/www/html

RUN cd /var/www \
    && git clone -b 2.1 --single-branch https://github.com/magento/magento2.git html

COPY ./auth.json /var/www/html/auth.json

RUN cd /var/www/html && composer install

RUN bin/magento setup:install \
    --admin-firstname=$MAGENTO_ADMIN_FIRSTNAME \
    --admin-lastname=$MAGENTO_ADMIN_LASTNAME \
    --admin-email=$MAGENTO_ADMIN_EMAIL \
    --admin-user=$MAGENTO_ADMIN_USERNAME \
    --admin-password=$MAGENTO_ADMIN_PASSWORD \
    --base-url=$MAGENTO_URL \
    --backend-frontname=$MAGENTO_ADMIN_URI \
    --db-host=$MYSQL_HOST \
    --db-name=$MYSQL_DATABASE \
    --db-user=$MYSQL_USER \
    --db-password=$MYSQL_PASSWORD \
    --timezone=$MAGENTO_TIMEZONE \
    --currency=$MAGENTO_DEFAULT_CURRENCY \
    --use-rewrites=$USE_REWRITE

RUN find . -type d -exec chmod 770 {} \; find . -type f -exec chmod 660 {} \; chmod u+x bin/magento
RUN chown -R www-data:www-data /var/www

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
