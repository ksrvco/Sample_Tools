#!/bin/bash
# Tool name: Auto Log Monitoring
# Tested on: Ubuntu Server , Nginx Webserver
# Run this script every 10 seconds with crontab.
# Requirements: nginx , goaccess
# Install goaccess:
# apt install libncursesw5-dev gcc make libgeoip-dev libtokyocabinet-dev build-essential
# wget https://tar.goaccess.io/goaccess-1.6.3.tar.gz
# tar xvf goaccess-1.6.3.tar.gz
# cd goaccess-1.6.3/
# ./configure  --enable-utf8 --enable-geoip=legacy
# make
# make install

webdir="/var/www/html"
mkdir -p /tmp/lomonitoring
rm -rf $webdir/lo-report.html
cp -r /var/log/nginx/access.log* /tmp/lomonitoring/
gzip -d /tmp/lomonitoring/*.gz
cat /tmp/lomonitoring/access.log* > /tmp/lomonitoring/nginx.logs
rm -rf /tmp/lomonitoring/access.log*
goaccess /tmp/lomonitoring/nginx.logs \
--log-format=COMBINED -a -o \
$webdir/lo-report.html > /dev/null 2>&1
