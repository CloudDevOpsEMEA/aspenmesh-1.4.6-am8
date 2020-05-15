#!/bin/bash

sudo service bind9 stop

sudo cp named.conf /etc/bind
sudo cp named.conf.local /etc/bind
sudo cp named.conf.options /etc/bind

sudo cp forward.aspen-demo.org /var/cache/bind
sudo cp named.conf.options /var/cache/bind

sudo chown -R bind:bind /etc/bind
sudo chown -R bind:bind /var/cache/bind
sudo chmod -R 666 /etc/bind
sudo chmod -R 666 /var/cache/bind

sudo mkdir -p /var/log/bind
sudo touch /var/log/named/client.log
sudo touch /var/log/named/config.log
sudo touch /var/log/named/default.log
sudo touch /var/log/named/dispatch.log
sudo touch /var/log/named/dnssec.log
sudo touch /var/log/named/general.log
sudo touch /var/log/named/lame_servers.log
sudo touch /var/log/named/network.log
sudo touch /var/log/named/queries.log
sudo touch /var/log/named/resolver.log
sudo touch /var/log/named/security.log
sudo touch /var/log/named/unmatched.log
sudo touch /var/log/named/update.log
sudo touch /var/log/named/update_security.log

sudo chown -R bind:bind /var/log/bind
sudo chmod -R 666 /var/log/bind

sudo service bind9 start
sleep 10
sudo service bind9 status
