FROM roura/php-magento:7.0

# Clone 2.1 branch
RUN cd /var/www \
    && git clone -b 2.1 --single-branch --verbose https://github.com/magento/magento2.git html \
    && cd html && composer install \
    && composer require mageplaza/magento-2-blog-extension:2.4.6 \
    && composer require mageplaza/magento-2-banner-slider-extension \
    && chmod u+x bin/magento \
    && mv package.json.sample package.json && npm install \
    && mv Gruntfile.js.sample Gruntfile.js && grunt

ADD env.php /var/www/html/app/etc
ADD config.php /var/www/html/app/etc
ADD .htaccess /var/www/html

RUN chown --recursive www-data:www-data /var/www
