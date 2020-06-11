#!/bin/bash
echo "Installing ElasticSearch package"
yum install -y --enablerepo=elasticsearch elasticsearch

echo "Move ElasticSearch configuration file"
mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch-bkp.yml

echo "Creating ElasticSearch configuration file"
cat <<EOF > /etc/elasticsearch/elasticsearch.yml
cluster.name: elasticsearch-1
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
network.host: 192.168.33.15
cluster.initial_master_nodes: ["192.168.33.15"]
discovery.seed_hosts: ["192.168.33.15"]
EOF

echo "Reload systemctl"
systemctl daemon-reload

echo "Enable Elasticsearch Service"
systemctl enable elasticsearch

echo "Restarting Elasticsearch Service"
systemctl restart elasticsearch