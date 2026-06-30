#!/bin/bash
DOMAIN=$1
SERVER_IP="172.17.177.2"

echo "nastrojka clienta"

echo "A-zapisi"
echo "$SERVER_IP $DOMAIN" >> /etc/hosts
echo "$SERVER_IP www.$DOMAIN" >> /etc/hosts

echo "get cert"
while [ ! -f /vagrant/server.crt ]; do
  sleep 2
done

cp /vagrant/server.crt /usr/local/share/ca-certificates/vagrant-server.crt
update-ca-certificates

echo "completed client"