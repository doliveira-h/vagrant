#!/bin/bash
# load environment variables
source /vagrant/env-vars.sh

yum install -y --enablerepo=elasticsearch elasticsearch

mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch-bkp.yml

cat <<EOF > /etc/elasticsearch/elasticsearch.yml
cluster.name: elasticsearch-1
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
network.host: 192.168.33.15
cluster.initial_master_nodes: ["192.168.33.15"]
discovery.seed_hosts: ["192.168.33.15"]
EOF

systemctl daemon-reload

systemctl enable elasticsearch

systemctl restart elasticsearch