#!/bin/bash

#wait for box
sleep 30

#hashicorp packages
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

#install packages
sudo apt update -y
sudo apt install awscli consul-enterprise=1.10.2+ent vault-enterprise=1.8.0+ent nomad-enterprise=1.0.4+ent docker.io jq -y

#pgk checks
#aws cli
aws --version
if [ $? -ne 0 ]
then
  echo "Error checking AWS cli version"
  exit 1
fi
#consul
consul --version
if [ $? -ne 0 ]
then
  echo "Error checking Consul version"
  exit 1
fi
#vault
vault --version
if [ $? -ne 0 ]
then
  echo "Error checking Vault version"
  exit 1
fi
#nomad
nomad --version
if [ $? -ne 0 ]
then
  echo "Error checking Nomad version"
  exit 1
fi
#docker
docker --version
if [ $? -ne 0 ]
then
  echo "Error checking Docker version"
  exit 1
fi
#jq
jq --version
if [ $? -ne 0 ]
then
  echo "Error checking jq version"
  exit 1
fi

exit 0
