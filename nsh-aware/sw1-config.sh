#!/usr/bin/env bash

set -e
hostnum=${HOSTNAME#"sfcpxy"}
sw="sw$hostnum"

echo do $sw settings.
