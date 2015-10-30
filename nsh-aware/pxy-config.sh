#!/usr/bin/env bash

set -e
hostnum=${HOSTNAME#"sfcpxy"}
sw="sw$hostnum"

#sudo ovs-ofctl add-flow $sw xxx

