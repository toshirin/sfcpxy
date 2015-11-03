#!/usr/bin/env bash

set -e
hostnum=${HOSTNAME#"sfcpxy"}
sw="sw$hostnum"

sudo arp -s 192.168.50.70 `ping -c 1 192.168.50.70 > /dev/null; arp 192.168.50.70 | grep 192.168.50.70 | awk '{print $3}'`

sudo ovs-vsctl add-br $sw
sudo ovs-vsctl add-port $sw eth1
sudo ovs-vsctl add-port $sw vxlan1 -- set interface vxlan1 type=vxlan options:key=flow options:dst_port="6633" options:remote_ip=192.168.60.73 options:nsp=flow options:nsi=flow

eth1_port=`sudo ovs-ofctl show $sw | grep eth1 | cut -d ' ' -f 2 | cut -d '(' -f 1`
vxlan1_port=`sudo ovs-ofctl show $sw | grep vxlan1 | cut -d ' ' -f 2 | cut -d '(' -f 1`

sudo ovs-ofctl del-flows $sw
sudo ovs-ofctl add-flow $sw table=0,in_port=$eth1_port,nw_src=192.168.50.70,actions=set_nsp:5,set_nsi:255,output:$vxlan1_port
sudo ovs-ofctl add-flow $sw table=0,in_port=$vxlan1_port,nw_src=192.168.50.70,actions=output:$eth1_port
sudo ovs-ofctl add-flow $sw table=1,arp,actions=normal
sudo ovs-ofctl dump-flows $sw

