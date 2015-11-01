#!/usr/bin/env bash

set -e

demo=${1%/}

echo $demo

cp $demo/infrastructure_config.py .

if ls $demo/*-config.sh > /dev/null 2>&1 ; then
    cp $demo/*-config.sh . 
    chmod 755 *-config.sh
fi

echo "Starting demo from $demo with vars:"
echo "Number of nodes: " $NUM_NODES
echo "Opendaylight Controller: " $ODL
echo "Base subnet: " $SUBNET

for i in `seq 1 $NUM_NODES`; do
  hostname="sfcpxy"$i
  echo $hostname
  vagrant ssh $hostname -c "sudo -E /vagrant/infrastructure_launch.py"
done

#echo "Configuring controller..."
#./$demo/rest.py

