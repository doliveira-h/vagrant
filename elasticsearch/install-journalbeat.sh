#!/bin/bash
echo "Installing Journalbeat package"
yum install  --enablerepo=elasticsearch -y journalbeat

echo "Move Journalbeat configuration file"
mv /etc/journalbeat/journalbeat.yml /etc/journalbeat/journalbeat-bkp.yml

echo "Creating Journalbeat configuration file"
cat <<EOF > /etc/journalbeat/journalbeat.yml
journalbeat.inputs:
- paths: []

setup.template.settings:
  index.number_of_shards: 1
  index.codec: best_compression

setup.kibana:
  host: "192.168.33.15:5601"

output.elasticsearch:
  hosts: ["192.168.33.15:9200"]

processors:
  - add_host_metadata: ~
  - add_cloud_metadata: ~
  - add_docker_metadata: ~
EOF

echo "Reload systemctl"
systemctl daemon-reload

echo "Enable Journalbeat Service"
systemctl enable journalbeat

echo "Restarting Journalbeat Service"
systemctl restart journalbeat

while [[ "$(curl -s -XGET -o /dev/null -L -w ''%{http_code}'' http://192.168.33.15:5601/status)" != "200" ]]; do
    echo 'Waiting for kibana get ready!'
    sleep 10
done

echo "Creating dashboards"
curl -X POST "192.168.33.15:5601/api/saved_objects/_import" -H 'kbn-xsrf: true' --form file=@/vagrant/dashboard-journal.ndjson