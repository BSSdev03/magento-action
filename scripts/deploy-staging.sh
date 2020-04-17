#!/bin/bash

set -e

PROJECT_PATH="$(pwd)"


echo "project path is $PROJECT_PATH";

which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )
eval $(ssh-agent -s)
mkdir ~/.ssh/ && echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa
ssh-add ~/.ssh/id_rsa
echo "$SSH_CONFIG" > /etc/ssh/ssh_config && chmod 600 /etc/ssh/ssh_config

touch auth.json

echo "$COMPOSER_AUTH" >> auth.json && chmod 600 auth.json

composer self-update --stable
composer update
composer install
php bin/magento setup:upgrade
php bin/magento setup:static-content:deploy en_US fr_Fr zh_Hant_TW en_CA  -f

rm -f app/etc/env.php
rm -f auth.json

echo "deploy to $HOST_DEPLOY_PATH"
echo "Move sites updated code to staging site"
rsync -e "ssh -o StrictHostKeyChecking=no -p 22" -avz ./ $USERNAME@$ADDRESS:$HOST_DEPLOY_PATH
ssh -o StrictHostKeyChecking=no -p 22 $USERNAME@$ADDRESS 'bash /home/cloudpanel/htdocs/test.glassesgallery.com/staging_deploy.sh'