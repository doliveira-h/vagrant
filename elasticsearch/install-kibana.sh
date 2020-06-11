#!/bin/bash
# load environment variables
source /vagrant/env-vars.sh

yum -y --enablerepo=elasticsearch install kibana

mv /etc/kibana/kibana.yml /etc/kibana/kibana-bkp.yml

cat <<EOF > /etc/kibana/kibana.yml
server.host: "192.168.33.15"
elasticsearch.hosts: ["http://192.168.33.15:9200"]
EOF

systemctl daemon-reload
systemctl enable kibana
systemctl restart kibana

