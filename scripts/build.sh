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


chmod +x bin/magento



#mkdir samplemage
#ls -al
#composer create-project --repository-url=https://repo.magento.com/ magento/project-enterprise-edition=2.3.2 samplemage
#mv samplemage/app/etc/env.php app/etc/
#mv samplemage/app/etc/config.php app/etc/

composer --version
composer global require hirak/prestissimo
composer install

bin/magento setup:install --admin-firstname="local" --admin-lastname="local" --admin-email="local@local.com" --admin-user="local" --admin-password="local123" --base-url="http://magento.build/" --backend-frontname="admin" --db-host="mysql" --db-name="magento2" --db-user="root" --db-password="magento" --use-secure=0 --use-rewrites=1 --use-secure-admin=0 --session-save="db" --currency="EUR" --language="en_US" --timezone="Europe/Rome"

#disable MSI module
php bin/magento module:disable -f Magento_Inventory Magento_InventoryAdminUi Magento_InventoryApi Magento_InventoryBundleProduct Magento_InventoryBundleProductAdminUi Magento_InventoryCatalog Magento_InventorySales Magento_InventoryCatalogAdminUi Magento_InventoryCatalogApi Magento_InventoryCatalogSearch Magento_InventoryConfigurableProduct Magento_InventoryConfigurableProductAdminUi Magento_InventoryConfigurableProductIndexer Magento_InventoryConfiguration Magento_InventoryConfigurationApi Magento_InventoryGroupedProduct Magento_InventoryGroupedProductAdminUi Magento_InventoryGroupedProductIndexer Magento_InventoryImportExport Magento_InventoryIndexer Magento_InventoryLowQuantityNotification Magento_InventoryLowQuantityNotificationAdminUi Magento_InventoryLowQuantityNotificationApi Magento_InventoryMultiDimensionalIndexerApi Magento_InventoryProductAlert Magento_InventoryReservations Magento_InventoryReservationsApi Magento_InventoryCache Magento_InventorySalesAdminUi Magento_InventorySalesApi Magento_InventorySalesFrontendUi Magento_InventoryShipping Magento_InventorySourceDeductionApi Magento_InventorySourceSelection Magento_InventorySourceSelectionApi Magento_InventoryShippingAdminUi Magento_InventoryDistanceBasedSourceSelectionAdminUi Magento_InventoryDistanceBasedSourceSelectionApi Magento_InventoryElasticsearch Magento_InventoryExportStockApi Magento_InventoryReservationCli Magento_InventoryExportStock Magento_CatalogInventoryGraphQl Magento_InventorySetupFixtureGenerator
php bin/magento module:disable -f Amazon_Login Amazon_Payment Amazon_Core Magento_Eway
#run necessary magento command
php bin/magento setup:upgrade
php bin/magento setup:di:compile
#php bin/magento deploy:mode:set --skip-compilation production
php bin/magento setup:static-content:deploy --jobs=5 en_US fr_CA fr_FR zh_Hant_TW en_CA -f

#composer dump-autoload -o

rm app/etc/env.php

#rm -rf samplemage
