#!/bin/bash
# load environment variables
source /vagrant/env-vars.sh

# install prereqs
apt-get -y install apt-transport-https software-properties-common wget

# download gpg key
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

# add grafana repository
add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

# update repositories
apt-get update

# install 
apt-get -y install grafana jq

# reload systemctl
systemctl daemon-reload

# configuring password grafana
sed -i 's/;admin_user.*$/admin_user = admin/g' /etc/grafana/grafana.ini
sed -i 's/;admin_password.*$/admin_password = '"$GRAFANA_PASSWORD"'/g' /etc/grafana/grafana.ini

# enable and restart grafana service
systemctl enable grafana-server && systemctl restart grafana-server

# create datasource prometheus
sleep 10
curl -s --user admin:$GRAFANA_PASSWORD 'http://localhost:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' \
--data-binary '{"name":"prometheus","isDefault":true ,"type":"prometheus","url":"http://192.168.33.15:9090","access":"proxy","basicAuth":false}'

# import dashboard
# https://grafana.com/grafana/dashboards/11074
DASH11074=$(curl -s --user admin:$GRAFANA_PASSWORD http://localhost:3000/api/gnet/dashboards/11074 | jq .json)
curl -s --user admin:$GRAFANA_PASSWORD -XPOST -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -d "{\"dashboard\":$DASH11074,\"overwrite\":true, \
        \"inputs\":[{\"name\":\"DS_PROMETHEUS_111\",\"type\":\"datasource\", \
        \"pluginId\":\"prometheus\",\"value\":\"prometheus\"}]}" \
    http://localhost:3000/api/dashboards/import