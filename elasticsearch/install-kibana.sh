#!/bin/bash
echo "Installing Kibana package"
yum -y --enablerepo=elasticsearch install kibana

echo "Move Kibana configuration file"
mv /etc/kibana/kibana.yml /etc/kibana/kibana-bkp.yml

echo "Creating Kibana configuration file"
cat <<EOF > /etc/kibana/kibana.yml
server.host: "192.168.33.15"
elasticsearch.hosts: ["http://192.168.33.15:9200"]
EOF

echo "Reload systemctl"
systemctl daemon-reload

echo "Enable Kibana Service"
systemctl enable kibana

echo "Restarting Kibana Service"
systemctl restart kibana

