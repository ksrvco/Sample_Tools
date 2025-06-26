#!/bin/bash
# Tool name: SSHoneyPot - SSH HoneyPot
# Tested on: Debian based servers
# You can using this script as a service on linux servers.
reset
sshoneypot_allow_user="x" # This user not exist on the server.
sshoneypot_port="22"
sshoneypot_listen_addr="0.0.0.0"
sshoneypot_config="/opt/sshoneypot.conf"
sshoneypot_logfile="/var/log/sshoneypot.log"
echo "Starting SSH Honeypot..."
rm -rf $sshoneypot_config
sleep 2
touch $sshoneypot_logfile
echo "Port $sshoneypot_port" > $sshoneypot_config
echo "ListenAddress $sshoneypot_listen_addr" >> $sshoneypot_config
echo "PermitRootLogin no" >> $sshoneypot_config
echo "PasswordAuthentication yes" >> $sshoneypot_config
echo "AllowUsers x" >> $sshoneypot_config
echo "SSHoneyPot started successfully.Press CTRL+C to stop."
echo "You can see log file from $sshoneypot_logfile"
/usr/sbin/sshd -D -e -f $sshoneypot_config -p $sshoneypot_port -E $sshoneypot_logfile
