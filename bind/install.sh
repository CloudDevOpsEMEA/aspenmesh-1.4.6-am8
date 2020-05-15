#!/bin/bash

set -x
sudo service bind9 stop

sudo cp named.conf /etc/bind
sudo cp named.conf.local /etc/bind
sudo cp named.conf.options /etc/bind

sudo cp forward.aspen-demo.org /var/cache/bind
sudo cp named.conf.options /var/cache/bind

sudo chown bind:bind /etc/bind
sudo chown bind:bind /var/cache/bind
sudo chmod 777 /etc/bind
sudo chmod 777 /var/cache/bind

sudo chown bind:bind /etc/bind/*
sudo chown bind:bind /var/cache/bind/*
sudo chmod 666 /etc/bind/*
sudo chmod 666 /var/cache/bind/*

sudo mkdir -p /var/log/bind
sudo touch /var/log/bind/client.log
sudo touch /var/log/bind/config.log
sudo touch /var/log/bind/default.log
sudo touch /var/log/bind/dispatch.log
sudo touch /var/log/bind/dnssec.log
sudo touch /var/log/bind/general.log
sudo touch /var/log/bind/lame_servers.log
sudo touch /var/log/bind/network.log
sudo touch /var/log/bind/queries.log
sudo touch /var/log/bind/resolver.log
sudo touch /var/log/bind/security.log
sudo touch /var/log/bind/unmatched.log
sudo touch /var/log/bind/update.log
sudo touch /var/log/bind/update_security.log

sudo chown -R bind:bind /var/log/bind
sudo chmod -R 777 /var/log/bind

sudo chown -R bind:bind /var/log/bind/*
sudo chmod -R 666 /var/log/bind/*

sudo service bind9 start
sleep 10
sudo service bind9 status
