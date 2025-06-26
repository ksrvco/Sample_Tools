#!/bin/bash
# This is sample script with bash script for break yescrypt algorithm linux shadow passwords.
read -p "Enter hash: " hash
param=$(echo $hash | awk -F "$" '{ print $3 }')
salt=$(echo $hash | awk -F "$" '{ print $4 }')
endsalt=$(echo $param'$'$salt)
for i in $(cat pass)
do
  generated=$(mkpasswd --method=yescrypt --salt=$endsalt $i)
  if [ $hash == $generated ]
    then
    echo "Password is: $i"
    exit
  fi
done
