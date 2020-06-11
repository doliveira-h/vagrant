#!/bin/bash
# load environment variables
source /vagrant/env-vars.sh

yum install  --enablerepo=elasticsearch -y journalbeat

mv /etc/journalbeat/journalbeat.yml /etc/journalbeat/journalbeat-bkp.yml

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

systemctl daemon-reload
systemctl enable journalbeat
systemctl restart journalbeat

while [[ "$(curl -s -XGET -o /dev/null -L -w ''%{http_code}'' http://192.168.33.15:5601/status)" != "200" ]]; do
    echo 'Waiting for kibana get ready!'
    sleep 10
done

echo "Creating dashboards"
curl -X POST "192.168.33.15:5601/api/saved_objects/_import" -H 'kbn-xsrf: true' --form file=@/vagrant/dashboard-journal.ndjson