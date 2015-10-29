#!/usr/bin/env bash

set -e
hostnum=${HOSTNAME#"pxysfc"}
sw="sw$hostnum"

sudo ifconfig eth2 up
sudo ifconfig eth3 up
sudo ovs-vsctl add-br $sw
sudo ovs-vsctl add-port $sw eth2
sudo ovs-vsctl add-port $sw eth3
sudo ovs-ofctl add-flow $sw actions=normal
host_addr=`expr $hostnum + 69`
sudo ifconfig $sw up
sudo ifconfig $sw 192.168.60.$host_addr

