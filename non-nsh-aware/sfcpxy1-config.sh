#!/usr/bin/env bash

set -e
hostnum=${HOSTNAME#"sfcpxy"}
sw="sw$hostnum"

sudo route add -net 192.168.80.0/24 gw 192.168.50.71
sudo arp -s 192.168.50.71 `ping -c 1 192.168.50.71 > /dev/null; arp 192.168.50.71 | grep 192.168.50.71 | awk '{print $3}'`

sudo ovs-vsctl add-br $sw

