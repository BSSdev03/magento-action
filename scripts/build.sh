#!/usr/bin/env bash

set -e

PROJECT_PATH="$(pwd)"

#Create Auth Json For Composer 
touch auth.json
echo "$COMPOSER_AUTH" >> auth.json && chmod 600 auth.json

composer --version
/usr/local/bin/composer update
/usr/local/bin/composer install

chmod +x bin/magento

mysqladmin -h mysql -u root -pmagento status

bin/magento setup:install \
--base-url=http://localhost/magento2ee \
--db-host=mysql \
--db-name=magento \
--db-user=root \
--db-password=magento \
--admin-firstname=admin \
--admin-lastname=admin \
--admin-email=admin@admin.com \
--admin-user=admin \
--admin-password=admin123 \
--language=en_US \
--currency=USD \
--timezone=America/Chicago \
--use-rewrites=1

#run necessary magento command
php bin/magento setup:upgrade
php bin/magento setup:di:compile
php bin/magento deploy:mode:set --skip-compilation production
php bin/magento setup:static-content:deploy en_US fr_Fr zh_Hant_TW en_CA  -f

composer dump-autoload -o

rm app/etc/env.php
