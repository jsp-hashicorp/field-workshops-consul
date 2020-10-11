#!/bin/bash

#metadata
local_ipv4=$(curl -s -H "Metadata-Flavor: Google" http://metadata/computeMetadata/v1/instance/network-interfaces/0/ip)
public_ipv4="$(curl -H "Metadata-Flavor: Google" http://metadata/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)"

#update packages
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update -y

#install consul
sudo apt install consul -y

#config
cat <<EOF> /etc/consul.d/client.json
{
  "datacenter": "gcp-us-central-1",
  "primary_datacenter": "aws-us-east-1",
  "advertise_addr": "$${local_ipv4}",
  "data_dir": "/opt/consul/data",
  "client_addr": "0.0.0.0",
  "log_level": "INFO",
  "retry_join": ["provider=gce tag_value=consul-${env}"],
  "ui": true,
  "connect": {
    "enabled": true
  },
  "ports": {
    "grpc": 8502
  }
}
EOF

mkdir -p /opt/consul/tls/
echo "${ca_cert}" > /opt/consul/tls/ca-cert.pem

cat <<EOF> /etc/consul.d/tls.json
{
  "verify_incoming": false,
  "verify_outgoing": true,
  "verify_server_hostname": true,
  "ca_file": "/opt/consul/tls/ca-cert.pem",
  "auto_encrypt": {
    "tls": true
  }
}
EOF

sudo systemctl enable consul.service
sudo systemctl start consul.service

sleep 120

curl -L https://getenvoy.io/cli | bash -s -- -b /usr/local/bin
getenvoy fetch standard:1.14.1
cp /root/.getenvoy/builds/standard/1.14.1/linux_glibc/bin/envoy /usr/local/bin/envoy
nohup consul connect envoy -expose-servers -gateway=mesh -register -service "mesh-gateway" -address "$${local_ipv4}:443" -wan-address "$${public_ipv4}:443" -- -l debug > /envoy.out &
exit 0