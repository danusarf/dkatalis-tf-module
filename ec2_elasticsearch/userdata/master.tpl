#!/bin/bash -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo BEGIN

sudo yum update -y
sudo yum install -y java-1.8.0-openjdk

# ElasticSearch Best Practice
sudo swapoff -a
sudo sysctl vm.swappiness=1

cat << EOF > /etc/sysctl.conf
vm.max_map_count=262144
net.ipv4.tcp_retries2=5
EOF


sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm || true
sudo systemctl start amazon-ssm-agent

sudo yum install perl-Digest-SHA -y
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.6.2-x86_64.rpm
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.6.2-x86_64.rpm.sha512
shasum -a 512 -c elasticsearch-8.6.2-x86_64.rpm.sha512 
sudo rpm --install elasticsearch-8.6.2-x86_64.rpm

mkdir -p /etc/systemd/system/elasticsearch.service.d
cat << EOF > /etc/systemd/system/elasticsearch.service.d/override.conf
[Service]
LimitMEMLOCK=infinity
EOF

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service

sudo systemctl start elasticsearch.service

elastic_password=$(yes | /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic | sed -n 's/.*New value: \(.*\)/\1/p')

aws secretsmanager create-secret --name ${secret_name}-cert --region=us-east-1 --secret-binary fileb:///etc/elasticsearch/certs/http_ca.crt || aws secretsmanager update-secret --secret-id ${secret_name}-cert --region=us-east-1 --secret-binary fileb:///etc/elasticsearch/certs/http_ca.crt
aws secretsmanager create-secret --name ${secret_name} --secret-string '{"elastic":'$elastic_password'}' --region=us-east-1 || aws secretsmanager update-secret --secret-id ${secret_name} --secret-string '{"elastic":'$elastic_password'}' --region=us-east-1

echo END
