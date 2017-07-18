#!/bin/sh

RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[m'

if [ "$1" = "full" ]
then
  printf "Full Deployment.\n"
else
  printf "Partial Deployment.\n"
fi

rm -rf pub/static/frontend
printf "${RED}Static files erased.${NC}\n"

php bin/magento setup:static-content:deploy en_AU
printf "${GREEN}Static files generated.${NC}\n"

if [ "$1" = "full" ]
then
  rm -rf var/di
  printf "${RED}Di folder erased.${NC}\n"

  php bin/magento setup:di:compile
  printf "${GREEN}Single-tenant compiler successfull.{$NC}\n"

  php bin/magento cache:clean
  printf "${GREEN}Cache cleared.${NC}\n"

  php bin/magento indexer:reindex
  printf "${GREEN}Index updated.${NC}\n"
fi

chown www-data:www-data -R /var/www/html
chmod 755 pub -R

printf "${GREEN}Deployment finished.${NC}\n"
