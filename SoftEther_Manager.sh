#!/bin/bash
# Tool name: SE-Manager - Softether VPN server manager
# Version: 1.0
# Tested on: Ubuntu server , Debian Server
reset
export PATH="$PATH:/usr/local/vpnserver"
hubpass="123456"
tmpath="/root/SEVSMpath"
sepath="/usr/local/vpnserver/security_log/VPN"
vpnname="VPN"
srvaddr="127.0.0.1"
semanageport="5555"

echo -e "

  ██████ ▓█████  ███▄ ▄███▓ ▄▄▄       ███▄    █  ▄▄▄        ▄████ ▓█████  ██▀███  
▒██    ▒ ▓█   ▀ ▓██▒▀█▀ ██▒▒████▄     ██ ▀█   █ ▒████▄     ██▒ ▀█▒▓█   ▀ ▓██ ▒ ██▒
░ ▓██▄   ▒███   ▓██    ▓██░▒██  ▀█▄  ▓██  ▀█ ██▒▒██  ▀█▄  ▒██░▄▄▄░▒███   ▓██ ░▄█ ▒
  ▒   ██▒▒▓█  ▄ ▒██    ▒██ ░██▄▄▄▄██ ▓██▒  ▐▌██▒░██▄▄▄▄██ ░▓█  ██▓▒▓█  ▄ ▒██▀▀█▄  
▒██████▒▒░▒████▒▒██▒   ░██▒ ▓█   ▓██▒▒██░   ▓██░ ▓█   ▓██▒░▒▓███▀▒░▒████▒░██▓ ▒██▒
▒ ▒▓▒ ▒ ░░░ ▒░ ░░ ▒░   ░  ░ ▒▒   ▓▒█░░ ▒░   ▒ ▒  ▒▒   ▓▒█░ ░▒   ▒ ░░ ▒░ ░░ ▒▓ ░▒▓░
░ ░▒  ░ ░ ░ ░  ░░  ░      ░  ▒   ▒▒ ░░ ░░   ░ ▒░  ▒   ▒▒ ░  ░   ░  ░ ░  ░  ░▒ ░ ▒░
░  ░  ░     ░   ░      ░     ░   ▒      ░   ░ ░   ░   ▒   ░ ░   ░    ░     ░░   ░ 
      ░     ░  ░       ░         ░  ░         ░       ░  ░      ░    ░  ░   ░     
                                                                                                                                                                                      

Tool name: SE-Manager - Softether VPN server manager
Written by : KsrvcO
Version: 2.1

1. Get list of listening ports
2. Remove a listening port
3. Create a listening port 
4. Enable OpenVPN
5. Get OpenVPN file config
6. Get created users info
7. Get users info updates
8. Get removed users info
9. Successfull Authenticated users
10. Failed Authentication users
11. Number of failed logins for each user
12. Get online users ontime
13. Transfered bytes for each user
14. List of users
15. Create user
16. Delete user
17. Add or Change password of users
18. Change user information like fullname and group name
19. Get number of users
20. Get number of online users
21. Set expired date for users
22. Get disabled users.
23. Enable user
24. Disable user
25. List of groups with number of members
26. Limit download for each user.
27. Limit upload for each user.
28. Remove user policies
29. Exit

"
read -p "[+] Enter your option (1-29): " option

if [ $option == 1 ]
then
	# Get list of listening ports
	vpncmd $srvaddr:$semanageport \
	/SERVER \
	/HUB:$vpnname \
	/PASSWORD:"$hubpass" \
	/CMD ListenerList  | \
	grep "Listening" | \
	cut -d "|" -f1

elif [ $option == 2 ]
then
	# Remove a listening port
	read -p "[+] Enter port number for remove: " portnum
	vpncmd $srvaddr:$semanageport \
	/SERVER \
	/PASSWORD:"$hubpass" \
	/CMD ListenerDelete $portnum | \
	grep "successfully"

elif [ $option == 3 ]
then
	# Create a listening port 
	read -p "[+] Enter port number for listen: " listenport
	vpncmd $srvaddr:$semanageport \
	/SERVER  \
	/PASSWORD:"$hubpass" \
	/CMD ListenerCreate $listenport | \
	grep "successfully"

elif [ $option == 4 ]
then
	# Enable OpenVPN
	# If any port will open on openvpn also you must listen this port on SE.
	vpncmd $srvaddr:$semanageport \
	/SERVER  \
	/PASSWORD:"$hubpass" \
	/CMD OpenVpnEnable
	grep "successfully"

elif [ $option == 5 ]
then
# Get OpenVPN file config
vpncmd $srvaddr:$semanageport \
/SERVER  \
/PASSWORD:"$hubpass" \
/CMD OpenVpnMakeConfig  OpenVPN-Configure.zip | \
grep "successfully"
echo "Saved as OpenVPN-Configure.zip"

elif [ $option == 6 ]
then
	# Get created users info
	cat $sepath/* | \
	grep "created" | \
	grep $vpnname | \
	grep -v "Group" | \
	awk -F ' ' '{print $10","$1","$2}' | \
	grep -v "been" | \
	sed 's/"//' | \
	sed 's/"//' | \
	sed 's/[.].*$//'

elif [ $option == 7 ]
then
	# Get users info updates
	cat $sepath/* | \
	grep "updated" | \
	grep $vpnname  | \
	grep -v "Group" | \
	awk -F ' ' '{print $13","$1","$2}' | \
	sed 's/"//' | sed 's/"//' | \
	sed 's/[.].*$//'

elif [ $option == 8 ]
then
	# Get removed users info
	cat $sepath/* | \
	grep "deleted" | \
	grep $vpnname | \
	grep -v "Group"  | \
	awk -F ' ' '{print $10","$1","$2}' | \
	sed 's/"//' | sed 's/"//' | \
	sed 's/[.].*$//' 

elif [ $option == 9 ]
then
	# Successfull Authenticated users
	cat $sepath/* | \
	grep "authenticated"  | \
	tr "." " " | \
	awk -F " " '{print $10,$1,$2}' | \
	tr " " , | \
	sort -u  | \
	sed 's/"//' | \
	sed 's/"//'

elif [ $option == 10 ]
then
	# Failed Authentication users
	cat $sepath/* | \
	grep "authentication failed" | \
	awk -F " " '{ print $1,$2,$16}' | \
	tr " " , | \
	sed 's/"//' | \
	sed 's/"//'  | \
	sed 's/\(.*\)\./\1/' | \
	sed -e 's/\..*,/,/' 

elif [ $option == 11 ]
then
	# Number of failed logins for each user
	read -p "[+] Enter username: " usname
	numbers=$(cat $sepath/* | \
	grep "authentication failed" | \
	cut -d '"' -f4 | \
	grep $usname | \
	wc -l)
	echo $usname:$numbers 

elif [ $option == 12 ]
then
	# Get online users ontime
	vpncmd $srvaddr:$semanageport \
	/SERVER \
	/HUB:$vpnname \
	/PASSWORD:"$hubpass" \
	/CMD sessionlist | 
	grep "User Name" | \
	grep -v "Cascade" |\
	awk -F "|" '{ print $2 }'

elif [ $option == 13 ]
then
	# Transfered bytes for each user
	read -p "[+] Enter username: " usnamee
	numbits=$(vpncmd $srvaddr:$semanageport \
	/SERVER \
	/HUB:$vpnname \
	/PASSWORD:"$hubpass" \
	/CMD userlist | \
	grep -e "User Name" -e "Transfer Bytes" | \
	tr "|" " "  | \
	awk ' {print;} NR % 2 == 0 { print ""; }' | \
	grep  "$usnamee"  -A 1 | \
	grep "Transfer Bytes" | \
	awk '{ print $3 }')
	echo $usnamee:$numbits

elif [ $option == 14 ]
then
	# List of users, Fullname, group name, number of logins, expired date 
	echo "Example Result:"
	echo "Username,FullName,GroupName,NumberLogins,ExpiredDate"
	echo ""
	for i in $(vpncmd $srvaddr:$semanageport /SERVER /HUB:$vpnname /PASSWORD:"$hubpass" /CMD userlist | grep -e "User Name" -e "Full Name" -e "Group Name" -e "Num Logins" -e "Expiration Date" | awk ' {print;} NR % 5 == 0 { print ""; }' | tr "|" " " | grep "User Name" | awk '{ print $3}')
	do
		fullname=$(vpncmd $srvaddr:$semanageport /SERVER /HUB:$vpnname /PASSWORD:"$hubpass" /CMD userlist | grep -e "User Name" -e "Full Name" -e "Group Name" -e "Num Logins" -e "Expiration Date" | awk ' {print;} NR % 5 == 0 { print ""; }' | tr "|" " " | grep "$i"  -A 1 | grep "Full Name" | awk '{ print $3 }')
		groupname=$(vpncmd $srvaddr:$semanageport /SERVER /HUB:$vpnname /PASSWORD:"$hubpass" /CMD userlist | grep -e "User Name" -e "Full Name" -e "Group Name" -e "Num Logins" -e "Expiration Date" | awk ' {print;} NR % 5 == 0 { print ""; }' | tr "|" " " | grep "$i"  -A 2 | grep "Group Name" | awk '{ print $3 }')
		numlogins=$(vpncmd $srvaddr:$semanageport /SERVER /HUB:$vpnname /PASSWORD:"$hubpass" /CMD userlist | grep -e "User Name" -e "Full Name" -e "Group Name" -e "Num Logins" -e "Expiration Date" | awk ' {print;} NR % 5 == 0 { print ""; }' | tr "|" " " | grep "$i"  -A 3 | grep "Num Logins" | awk '{ print $3 }')
		expiredate=$(vpncmd $srvaddr:$semanageport /SERVER /HUB:$vpnname /PASSWORD:"$hubpass" /CMD userlist | grep -e "User Name" -e "Full Name" -e "Group Name" -e "Num Logins" -e "Expiration Date" | awk ' {print;} NR % 5 == 0 { print ""; }' | tr "|" " " | grep "$i"  -A 4 | grep "Expiration Date" | awk '{ print $3 }')
		echo "$i,$fullname,$groupname,$numlogins,$expiredate"
	done
elif [ $option == 15 ]
then
	# Create user
	read -p "[+] Enter username for create: " uusname
	vpncmd $srvaddr:$semanageport \
	/SERVER \
	/HUB:$vpnname \
	/PASSWORD:"$hubpass" \
	/CMD UserCreate $uusname \
	/GROUP:none \
	/REALNAME:$uusname \
	/NOTE:none | \
	grep "successfully"
	vpncmd $srvaddr:$semanageport \
	/SERVER \
	/HUB:$vpnname \
	/PASSWORD:"$hubpass" \
	/CMD UserPolicySet $uusname \
	/NAME:Access \
	/VALUE:yes | \
	grep "successfully"

elif [ $option == 16 ]
then
	# Delete user
	read -p "[+] Enter username: " unamee
	vpncmd $srvaddr:$semanageport \
	/SERVER \
	/HUB:$vpnname \
	/PASSWORD:"$hubpass" \
	/CMD UserDelete $unamee | \
	grep "successfully"

elif [ $option == 17 ]
then
	# Add or Change password of users
	read -p "[+] Enter username: " unames
	read -p "[+] Enter password: " passwdd
	vpncmd $srvaddr:$semanageport \
	/SERVER \
	/HUB:$vpnname \
	/PASSWORD:"$hubpass" \
	/CMD UserPasswordSet $unames \
	/PASSWORD:'$passwdd' | \
	grep "successfully"


elif [ $option == 18 ]
then
	# Change user information like fullname and group name
	read -p "[+] Enter Username: " namer
	read -p "[+] Enter Groupname: " gpname
	read -p "[+] Enter Realname: " realnames
	vpncmd $srvaddr:$semanageport \
	/SERVER \
	/HUB:$vpnname \
	/PASSWORD:"$hubpass" \
	/CMD userset $namer \
	/GROUP:$gpname \
	/REALNAME:$realnames \
	/NOTE:none | \
	grep "successfully"

elif [ $option == 19 ]
then
	# Get number of users
	vpncmd $srvaddr:$semanageport \
	/SERVER \
	/HUB:$vpnname \
	/PASSWORD:"$hubpass" \
	/CMD userlist | \
	grep "User Name" | \
	wc -l

elif [ $option == 20 ]
then
	# Get number of online users
	vpncmd $srvaddr:$semanageport \
	/SERVER \
	/HUB:$vpnname \
	/PASSWORD:"$hubpass" \
	/CMD sessionlist | 
	grep "User Name" | \
	grep -v "Cascade" | \
	awk -F "|" '{ print $2 }' | \
	wc -l

elif [ $option == 21 ]
then
	# Set expired date for users
	read -p "[+] Enter Username: " nameus
	read -p "[+] Enter Year: " year
	read -p "[+] Enter Month: " month
	read -p "[+] Enter Day: " day
	read -p "[+] Enter Hour: " hour
	read -p "[+] Enter Minute: " minute
	read -p "[+] Enter Second: " second
	vpncmd $srvaddr:$semanageport \
	/SERVER \
	/HUB:$vpnname \
	/PASSWORD:"$hubpass" \
	/CMD UserExpiresSet $nameus \
	/EXPIRES:"$year/$month/$day $hour:$minute:$second" | \
	grep "successfully"

elif [ $option == 22 ]
then
	# Get disabled users. User status must be select acces yes or no when a user will create.
	vpncmd $srvaddr:$semanageport \
	/SERVER \
	/HUB:$vpnname \
	/PASSWORD:"$hubpass" \
	/CMD userlist | \
	grep "User Name" | \
	awk -F "|" '{ print $2 }' > /tmp/dis-users.txt
	for i in $(cat '/tmp/dis-users.txt')
	do
		disabled=$(vpncmd $srvaddr:$semanageport \
			/SERVER \
			/HUB:$vpnname \
			/PASSWORD:"$hubpass" \
			/CMD userget $i | \
			grep "Access" | \
			grep "Yes")
		if [ -n "$disabled" ]
		then
		    echo "" > /dev/null
		else
		    echo "$i"
		fi
	done
	rm -rf  /tmp/dis-users.txt

elif [ $option == 23 ]
then
	# Enable user
	read -p "[+] Enter Username: " usernme
	vpncmd $srvaddr:$semanageport \
	/SERVER \
	/HUB:$vpnname \
	/PASSWORD:"$hubpass" \
	/CMD UserPolicySet $usernme \
	/NAME:Access \
	/VALUE:yes | \
	grep "successfully"

elif [ $option == 24 ]
then
	# Disable user
	read -p "[+] Enter Username: " usernmeee
	vpncmd $srvaddr:$semanageport \
	/SERVER \
	/HUB:$vpnname \
	/PASSWORD:"$hubpass" \
	/CMD UserPolicySet $usernmeee \
	/NAME:Access \
	/VALUE:no | \
	grep "successfully"

elif [ $option == 25 ]
then
	# List of groups with number of members
	for i in $(vpncmd $srvaddr:$semanageport /SERVER /HUB:$vpnname /PASSWORD:"$hubpass" /CMD grouplist | grep -e "Group Name" -e "Num Users" | tr "|" " " | awk ' {print;} NR % 2 == 0 { print ""; }' | grep "Group Name" | awk '{ print $3 }')
	do
		num_users=$(vpncmd $srvaddr:$semanageport /SERVER /HUB:$vpnname /PASSWORD:"$hubpass" /CMD grouplist | grep -e "Group Name" -e "Num Users" | tr "|" " " | awk ' {print;} NR % 2 == 0 { print ""; }' | grep "$i"  -A 1 | grep "Num Users" | awk '{ print $3 }')
		echo "$i,$num_users"
	done

elif [ $option == 26 ]
then
	# Limit download for each user. ex: $speed=103
	read -p "[+] Enter Username: " unames
	read -p "[+] Enter Speed (bps = ): " speeds
	vpncmd $srvaddr:$semanageport \
	/SERVER \
	/HUB:$vpnname \
	/PASSWORD:"$hubpass" \
	/CMD userpolicyset $unames \
	/NAME:MaxDownload \
	/VALUE:$speeds | \
	grep "successfully"

elif [ $option == 27 ]
then
	# Limit upload for each user. ex: $speed=100
	read -p "[+] Enter Username: " unames
	read -p "[+] Enter Speed (bps = ): " speeds
	vpncmd $srvaddr:$semanageport \
	/SERVER \
	/HUB:$vpnname \
	/PASSWORD:"$hubpass" \
	/CMD userpolicyset $unames \
	/NAME:MaxUpload \
	/VALUE:$speeds | \
	grep "successfully"

elif [ $option == 28 ]
then
	# Remove user policies
	read -p "[+] Enter Username: " unames
	vpncmd $srvaddr:$semanageport \
	/SERVER \
	/HUB:$vpnname \
	/PASSWORD:"$hubpass" \
	/CMD  UserPolicyRemove $unames | \
	grep "successfully"
	vpncmd $srvaddr:$semanageport \
	/SERVER \
	/HUB:$vpnname \
	/PASSWORD:"$hubpass" \
	/CMD userpolicyset $unames \
	/NAME:Access \
	/VALUE:Yes | \
	grep "successfully"

elif [ $option == 29 ]
then
	exit
fi
exit
