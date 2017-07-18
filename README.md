# Magento 2.1 Dockerfile
- Based on `php:7.0-apache`.

[![Docker build](http://dockeri.co/image/roura/magento2.1)](https://hub.docker.com/r/roura/magento2.1/)

## Magento 2 installation made easy
After running this `Dockerfile` you will have:
- Debian Jessie
- PHP 7.0
- Apache 2.4
- Composer
- Node
- Grunt

### How to run
- Add `magento2.docker` to your `/etc/hosts` file (i.e., `127.0.0.1 magento2.docker`).
- Run `docker-compose build && docker-compose up -d`.
- Visit your newly-created [magento2.docker](http://magento2.docker/).
