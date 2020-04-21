#!/usr/bin/env bash

set -e

PROJECT_PATH="$(pwd)"

#Create Auth Json For Composer 
touch auth.json
echo "$COMPOSER_AUTH" >> auth.json && chmod 600 auth.json


mysqladmin -h mysql -u root -pmagento status

#check db magento exists
echo "check db magento exist";

mysqladmin -h mysql -u root -pmagento create magento2


composer --version
/usr/local/bin/composer install --no-dev --no-progress

chmod +x bin/magento

rm -f ./app/etc/env.php

mkdir samplemage
composer create-project --repository-url=https://repo.magento.com/ magento/project-enterprise-edition samplemage
samplemage/bin/magento setup:install --admin-firstname="local" --admin-lastname="local" --admin-email="local@local.com" --admin-user="local" --admin-password="local123" --base-url="http://magento.build/" --backend-frontname="admin" --db-host="mysql" --db-name="magento2" --db-user="root" --db-password="magento" --use-secure=0 --use-rewrites=1 --use-secure-admin=0 --session-save="db" --currency="EUR" --language="en_US" --timezone="Europe/Rome" --cleanup-database --skip-db-validation

#run necessary magento command
php bin/magento setup:upgrade
php bin/magento setup:di:compile
php bin/magento deploy:mode:set --skip-compilation production
php bin/magento setup:static-content:deploy en_US fr_Fr zh_Hant_TW en_CA  -f

composer dump-autoload -o

rm app/etc/env.php
