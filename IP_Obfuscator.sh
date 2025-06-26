#!/bin/bash
# Tool name: IP Obfuscator
# Tested on: All Linux Systems that using bash
clear
read -p "IPv4 address to obfuscate: " ip
if ! [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "This is not valid ip address: $ip"
    exit 1
fi
IFS='.' read -r -a ipmod <<< "$ip"
first=${ipmod[0]}
hex=$(printf "%x" "$first")
decimal=0
for ((i = 1; i < 4; i++)); do
    decimal=$((decimal + ${ipmod[$i]} * 256 ** (3 - i)))
done

final_obfuscated_ip="0x$hex.$decimal"
echo -e "\nYour obfuscated IP address is: \e[33m$final_obfuscated_ip\e[0m"
