#!/bin/bash
# About script: Visited websites monitoring in VPN networks
# Tested on this VPN servers: Wireguard , OpenVPN
# Run this script in the background.
intname="ens160"
while true
do
    tshark -i $intname -a duration:30 -Tfields -e tls.handshake.extensions_server_name -w /root/output/out.pcapng
    tshark  -T fields -e tls.handshake.extensions_server_name -r /root/output/out.pcapng | sed '/^[[:space:]]*$/d'  | sort -u >> /root/output/FinalResult.txt
done
