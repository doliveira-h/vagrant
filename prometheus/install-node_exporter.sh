#!/bin/bash
# load environment variables
source /vagrant/env-vars.sh

# create node_exporter
useradd --no-create-home --shell /bin/false node_exporter

# download node_exporter
echo "Downloading:  https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORT_VERSION}/${NODE_EXPORT_PKG}.tar.gz"
curl -s -L -o /tmp/node_exporter.tar.gz https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORT_VERSION}/${NODE_EXPORT_PKG}.tar.gz

# extract to tmp dir
tar xfz /tmp/node_exporter.tar.gz -C /tmp

# copy binary files to /usr/local/bin
cp -f /tmp/${NODE_EXPORT_PKG}/node_exporter /usr/local/bin/

# change owner
chown node_exporter:node_exporter /usr/local/bin/node_exporter

# remove files
rm -f /tmp/node_exporter.tar.gz && rm -fr /tmp/${NODE_EXPORT_PKG}

# create service node_exporter
cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# reload systemctl
systemctl daemon-reload

# enable and start node_exporter service
systemctl enable --now node_exporter