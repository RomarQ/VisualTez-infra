#!/bin/bash

set -o pipefail

NETWORK=$1
# Get the script location
SCRIPT_LOCATION=$(dirname "$0")

if [[ -z $NETWORK ]]
then
  echo "Usage:"
  echo " $0 <NETWORK>"
  exit
fi

# Install certbot
sudo apt-get update
sudo apt install certbot python3-certbot-nginx

# Remove default configuration
rm /etc/nginx/sites-enabled/default

# Replace configuration values based on network name
rm /etc/nginx/conf.d/*
cp "$SCRIPT_LOCATION"/etc/nginx/conf.d/rpc.conf /etc/nginx/conf.d/$NETWORK.conf
sed -i "s/{}.visualtez.com/$NETWORK.visualtez.com/" /etc/nginx/conf.d/$NETWORK.conf

# Verify the configuration syntax and restart NGINX
nginx -t && nginx -s reload

# Generate certificates with the NGINX plug‑in
certbot --nginx --agree-tos --non-interactive --register-unsafely-without-email -d "$NETWORK".visualtez.com

# Add cron job to automatically renew Let’s Encrypt certificates
(crontab -l ; echo "0 12 * * * /usr/bin/certbot renew --quiet")| crontab -
