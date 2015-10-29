#!/usr/bin/env bash

set -e

ODL=$1

for i in `seq 1 $NUM_NODES`; do
  hostname="sfcpxy"$i
  switchname="sw"$i
  echo $hostname
  vagrant ssh $hostname -c "sudo ovs-vsctl del-br $switchname; sudo ovs-vsctl del-manager; sudo /vagrant/clean.sh"

done
 

