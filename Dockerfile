FROM roura/php-magento:7.0
MAINTAINER Alberto Roura <mail@albertoroura.com>

# Clone 2.1 branch
RUN cd /var/www \
    && git clone -b 2.1 --single-branch --verbose https://github.com/magento/magento2.git html \
    && cd html && composer install \
    && composer require mageplaza/magento-2-blog-extension \
    && composer require mageplaza/magento-2-banner-slider-extension \
    && chmod u+x bin/magento \
    && mv package.json.sample package.json && npm install \
    && mv Gruntfile.js.sample Gruntfile.js && grunt \
    && chown --recursive www-data:www-data /var/www
