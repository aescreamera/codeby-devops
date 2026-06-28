#!/bin/bash
mkdir -p /home/vagrant/.ssh
cp /vagrant/.vagrant/machines/server/virtualbox/private_key /home/vagrant/.ssh/server_key
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/server_key