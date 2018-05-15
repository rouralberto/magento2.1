#!/usr/bin/env bash

/usr/local/bin/php /var/www/html/bin/magento cron:run

chown -R www-data:www-data app/design/frontend var pub
