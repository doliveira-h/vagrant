#!/bin/bash
# load environment variables
source /vagrant/env-vars.sh

# update repositories
apt-get update

# install apache2 and php
apt-get -y install apache2 php php-mysql 

# enable apache2 service
systemctl enable apache2

# download wordpress latest
curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz

# extract to tmp dir
tar xfz /tmp/wordpress.tar.gz -C /tmp

# move files to wordpress dir
mv /tmp/wordpress/* $WP_DIR

# rename config-sample
mv $WP_DIR/wp-config-sample.php $WP_DIR/wp-config.php

# remove files
rm -f /tmp/wordpress.tar.gz && rm -f $WP_DIR/index.html

# configure database
sed -i 's/username_here/'"$WP_USER"'/g' $WP_DIR/wp-config.php
sed -i 's/database_name_here/'"$WP_DBNAME"'/g' $WP_DIR/wp-config.php
sed -i 's/password_here/'"$WP_PASSWORD"'/g' $WP_DIR/wp-config.php
sed -i 's/localhost/'"$WP_DBHOST"'/g' $WP_DIR/wp-config.php

# restart apache2 service
systemctl restart apache2