#!/usr/bin/env bash


##
## Download new version
##

cd /tmp
wget -q https://totp.maverickgeek.xyz/index.html
if [ $? -ne 0 ]; then
	exit
fi

##
## Install new version
##

chmod 0644 index.html
chown root:wheel index.html
mv index.html /usr/local/www/nginx/index.html
