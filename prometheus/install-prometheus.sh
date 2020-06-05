#!/bin/bash
# load environment variables
source /vagrant/env-vars.sh

# create prometheus user
useradd --no-create-home --shell /bin/false prometheus

# create directories
mkdir /etc/prometheus && mkdir /var/lib/prometheus

# download prometheus 2.18.1
echo "Downloading:  https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/$PROMETHEUS_PKG.tar.gz"
curl -s -L -o /tmp/prometheus.tar.gz https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/$PROMETHEUS_PKG.tar.gz

# extract to tmp dir
tar xfz /tmp/prometheus.tar.gz -C /tmp

# copy binary files to /usr/local/bin
cp -f /tmp/$PROMETHEUS_PKG/prometheus /usr/local/bin/
cp -v /tmp/$PROMETHEUS_PKG/promtool /usr/local/bin/

# copy configuration files to /etc
cp -r /tmp/$PROMETHEUS_PKG/consoles /etc/prometheus
cp -r /tmp/$PROMETHEUS_PKG/console_libraries /etc/prometheus

# remove files
rm -f /tmp/prometheus.tar.gz && rm -fr /tmp/$PROMETHEUS_PKG

# add hosts
echo "192.168.33.15 prometheus" >> /etc/hosts
echo "192.168.33.10 grafana" >> /etc/hosts

cat <<EOF > /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['prometheus:9100','grafana:9100']
EOF

cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

# change owner
chown prometheus:prometheus /etc/prometheus 
chown prometheus:prometheus /var/lib/prometheus
chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool
chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries
chown prometheus:prometheus /etc/prometheus/prometheus.yml

# reload systemctl
systemctl daemon-reload

# enable and start prometheus
systemctl enable --now prometheus