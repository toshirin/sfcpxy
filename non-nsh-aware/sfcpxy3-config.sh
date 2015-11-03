#!/usr/bin/env bash

set -e
hostnum=${HOSTNAME#"sfcpxy"}
sw="sw$hostnum"

sudo ovs-vsctl add-br $sw
sudo ovs-vsctl add-port $sw eth3

sudo ovs-vsctl add-port $sw vxlan1 -- set interface vxlan1 type=vxlan options:key=flow options:dst_port="6633" options:remote_ip=192.168.60.71 options:nsp=flow options:nsi=flow

eth3_port=`sudo ovs-ofctl show $sw | grep eth3 | cut -d ' ' -f 2 | cut -d '(' -f 1`
vxlan1_port=`sudo ovs-ofctl show $sw | grep vxlan1 | cut -d ' ' -f 2 | cut -d '(' -f 1`

sudo ovs-ofctl del-flows $sw
sudo ovs-ofctl add-flow $sw table=0,in_port=$vxlan1_port,nsp=5,nsi=255,actions=output:$eth3_port
sudo ovs-ofctl add-flow $sw table=0,in_port=$eth3_port,nw_src=192.168.50.70,actions=set_nsp:5,set_nsi:254,output:$vxlan1_port
sudo ovs-ofctl add-flow $sw table=1,arp,actions=normal
sudo ovs-ofctl dump-flows $sw

