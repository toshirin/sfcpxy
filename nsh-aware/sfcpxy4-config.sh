#!/usr/bin/env bash

set -e
hostnum=${HOSTNAME#"sfcpxy"}
sw="sw$hostnum"

sudo ovs-vsctl add-br $sw
sudo ovs-vsctl add-port $sw eth3
sudo ovs-vsctl add-port $sw vxlan1 -- set interface vxlan1 type=vxlan options:key=flow options:dst_port="6633" options:remote_ip=192.168.60.71 options:nsp=flow options:nsi=flow

vxlan1_port=`sudo ovs-ofctl show $sw | grep vxlan1 | cut -d ' ' -f 2 | cut -d '(' -f 1`

ovs-ofctl del-flows $sw
ovs-ofctl add-flow $sw table=0,in_port=$vxlan1_port,actions=set_nsi:254,IN_PORT
ovs-ofctl add-flow $sw table=1,arp,actions=normal
ovs-ofctl dump-flows $sw

