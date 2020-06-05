#!/bin/bash
# load environment variables
source /vagrant/env-vars.sh

# update repositories
apt-get update

# install mysql-server
apt-get -y install mysql-server 

# configure mysqld.cnf to bind to all interfaces
sed -i 's/bind-address.*$/bind-address = 0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf

# enable and restart mysql service
systemctl enable mysql && systemctl restart mysql

# create database and user
mysql -e "CREATE DATABASE $WP_DBNAME;"
mysql -e "GRANT ALL PRIVILEGES ON $WP_DBNAME.* TO '$WP_USER'@'%' IDENTIFIED BY '$WP_PASSWORD';"
mysql -e "FLUSH PRIVILEGES;"