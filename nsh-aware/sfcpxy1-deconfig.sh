#!/usr/bin/env bash

set -e
hostnum=${HOSTNAME#"sfcpxy"}
sw="sw$hostnum"

sudo route delete -net 192.168.80.0/24 gw 192.168.50.71
sudo arp -d 192.168.50.71

