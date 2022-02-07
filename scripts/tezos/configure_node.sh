#!/bin/bash

set -o pipefail

SCRIPT_LOCATION=$(dirname "$0")
BUILD_ID=2008253594
NETWORK=$1
if [[ -z $NETWORK ]]
then
  echo "Usage:"
  echo " $0 <NETWORK>"
  exit
fi

# Go to attached disk
cd /mnt/disks/d1

# Download Tezos binaries
apt install unzip
wget -O tezos-binaries.zip "https://gitlab.com/tezos/tezos/-/jobs/${BUILD_ID}/artifacts/download"
unzip tezos-binaries.zip

# Initialize Zcash parameters
wget -O - https://raw.githubusercontent.com/zcash/zcash/master/zcutil/fetch-params.sh | sh

# Bootstrap node configuration
tezos-binaries/tezos-node config init --network $NETWORK --data-dir /mnt/disks/d1/.tezos-node

# Generate identity
tezos-binaries/tezos-node identity generate --data-dir /mnt/disks/d1/.tezos-node

# Deploy systemd services
cp "$SCRIPT_LOCATION/systemd/system/tezos-node.service" /etc/systemd/system/tezos-node.service
cp "$SCRIPT_LOCATION/systemd/system/tezos-baker-hangzhou.service" /etc/systemd/system/tezos-baker-hangzhou.service
cp "$SCRIPT_LOCATION/systemd/system/tezos-baker-ithaca.service" /etc/systemd/system/tezos-baker-ithaca.service
cp "$SCRIPT_LOCATION/systemd/system/tezos-endorser.service" /etc/systemd/system/tezos-endorser.service

systemctl daemon-reload
