#!/bin/bash
echo "Importing Elasticsearch GPG-KEY"
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

echo "Creating Repository Configuration"
cat <<EOF > /etc/yum.repos.d/elasticsearch.repo
[elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=0
autorefresh=1
type=rpm-md
EOF
