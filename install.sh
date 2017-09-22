#!/usr/bin/env bash

# Install Magento
/var/www/html/bin/magento setup:install \
--admin-firstname=$MAGENTO_ADMIN_FIRSTNAME \
--admin-lastname=$MAGENTO_ADMIN_LASTNAME \
--admin-email=$MAGENTO_ADMIN_EMAIL \
--admin-user=$MAGENTO_ADMIN_USERNAME \
--admin-password=$MAGENTO_ADMIN_PASSWORD \
--base-url=$MAGENTO_URL \
--backend-frontname=$MAGENTO_ADMIN_URI \
--db-host=$MYSQL_HOST \
--db-name=$MYSQL_DATABASE \
--db-user=root \
--db-password=$MYSQL_PASSWORD \
--timezone=$MAGENTO_TIMEZONE \
--currency=$MAGENTO_DEFAULT_CURRENCY \
--use-rewrites=$USE_REWRITE

# Set file permissions
chown -R www-data:www-data /var/www/html

# Run apache in the foreground
apache2-foreground
