#!/usr/bin/env bash

set -e
hostnum=${HOSTNAME#"sfcpxy"}
sw="sw$hostnum"

sudo ovs-vsctl add-br $sw
sudo ovs-vsctl add-port $sw eth3

eth3_port=`sudo ovs-ofctl show $sw | grep eth3 | cut -d ' ' -f 2 | cut -d '(' -f 1`

sudo ovs-ofctl del-flows $sw
sudo ovs-ofctl add-flow $sw table=0,in_port=$eth3_port,actions=IN_PORT
sudo ovs-ofctl add-flow $sw table=1,arp,actions=normal
sudo ovs-ofctl dump-flows $sw

