#!/bin/bash
# This script can sort nginx visited sources by countries.
rm -rf ips.txt
cat nginxlogs.txt | awk '{ print $1}' | sort -u >> ips.txt
for i in $(cat ips.txt)
do
ip=$(geoiplookup $i | awk '{ print $4 }' | cut -d "," -f1)
echo $ip >> country.txt
cat country.txt | sort | uniq -c  | sort -u | awk '{ print $2" "$1}' > result.txt
done
cat result.txt  | termgraph | awk -v FS='.' '{print $1}'
rm -rf ips.txt
rm -rf country.txt
rm -rf result.txt
