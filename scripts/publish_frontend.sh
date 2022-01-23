#!/bin/bash

set -o pipefail

# Download frontend
rm -rf /tmp/VisualTez
git clone https://github.com/TezWell/VisualTez.git /tmp/VisualTez

# Build for production
cd /tmp/VisualTez
yarn
yarn build

# Remove old files and publish new files
gsutil rm -a gs://visualtez.com/**
gsutil rsync -R /tmp/VisualTez/build gs://visualtez.com
