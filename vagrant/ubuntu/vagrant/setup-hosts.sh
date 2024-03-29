#!/bin/bash
set -e
IFNAME=$1
ADDRESS="$(ip -4 addr show $IFNAME | grep "inet" | head -1 |awk '{print $2}' | cut -d/ -f1)"
sed -e "s/^.*${HOSTNAME}.*/${ADDRESS} ${HOSTNAME} ${HOSTNAME}.local/" -i /etc/hosts

# remove ubuntu-bionic entry
sed -e '/^.*ubuntu-bionic.*/d' -i /etc/hosts

# Update /etc/hosts about other hosts
cat >> /etc/hosts <<EOF
192.168.1.11  master-1
192.168.1.12  master-2
192.168.1.21  node-1
192.168.1.22  node-2
192.168.1.23  node-3
192.168.1.30  lb
192.168.1.40  proxy
192.168.1.200  st
EOF
sudo apt-get update && sudo apt-get -y upgrade