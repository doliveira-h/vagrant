#!/bin/bash
# load environment variables
source ./env-vars.sh

apt-get update
# install mysql-server
apt-get -y install mysql-server 

# configure mysqld.cnf to bind to all interfaces
sed -i 's/bind-address.*$/bind-address = 0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf

# enable and restart mysql service
systemctl enable mysql && systemctl restart mysql

# create database and user
mysql -e "create database $WP_DBNAME;"
mysql -e "create user '$WP_USER'@'%' identified by '$WP_PASSWORD';"
mysql -e "flush privileges;"
mysql -e "grant all privileges on $WP_DBNAME.* to '$WP_USER'@'%';"
