#!/bin/sh

#MIT Licence 
#Copyright (c) Ethan Perry, Andy Lyu

#Welcome to CyberPatriot. I'll be your guide.
if (whoami != root)
  then echo "Please run as root"

  else (
#--------- Manual File Inspection ----------------
nano /etc/apt/sources.list #check for malicious sources
nano /etc/resolv.conf #make sure if safe, use 8.8.8.8 for name server
nano /etc/hosts #make sure is not redirecting
nano /etc/rc.local #should be empty except for 'exit 0'
nano /etc/sysctl.conf #change net.ipv4.tcp_syncookies entry from 0 to 1
nano /etc/lightdm/lightdm.conf #allow_guest=false, remove autologin
nano /etc/ssh/sshd_config #Look for PermitRootLogin and set to no
crontab -e #make sure crontab is empty

#--------- Manual Network Inspection ----------------
lsof  -i -n -P
netstat -tulpn

#--------- Update Using Apt-Get ----------------
apt-get update --no-allow-insecure-repositories
apt-get dist-upgrade -y
apt-get install -f -y
apt-get autoremove -y
apt-get autoclean -y
apt-get check

#--------- Download programs ----------------
apt-get install  -y hardinfo chkrootkit portsentry lynis ufw sysv-rc-conf nessus clamav rkhunter apparmor apparmor-profiles
apt-get install  -y --reinstall coreutils

#--------- Delete em' pirates, eh? (Delete Dangerous Files) ----------------
find / -name '*.mp3' -type f -delete
find / -name '*.mov' -type f -delete
find / -name '*.mp4' -type f -delete
find / -name '*.avi' -type f -delete
find / -name '*.mpg' -type f -delete
find / -name '*.mpeg' -type f -delete
find / -name '*.flac' -type f -delete
find / -name '*.m4a' -type f -delete
find / -name '*.flv' -type f -delete
find / -name '*.ogg' -type f -delete
find /home -name '*.gif' -type f -delete
find /home -name '*.png' -type f -delete
find /home -name '*.jpg' -type f -delete
find /home -name '*.jpeg' -type f -delete
cd / && ls -laR | grep rwxrwxrwx | grep -v "lrwx" &> /tmp/777s
echo "777 Files: "
cat /tmp/777s

#--------- Setup Firewall ----------------
#Please verify that the firewall wont block any services, such as an Email server, when defaulted.
#I will back up iptables for you in and put it in /iptables/rules.v4.bak and /iptables/rules.v6.bak

#Backup
mkdir /iptables/
iptables-save > /iptables/rules.v4.bak
ip6tables-save > /iptables/rules.v6.bak

#Uninstall UFW and install iptables
apt-get purge ufw
apt-get install iptables
apt-get install ip6tables

#Clear out and default iptables
iptables -t nat -F
iptables -t mangle -F
iptables -t nat -X
iptables -t mangle -X
iptables -F
iptables -X
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

ip6tables -t nat -F
ip6tables -t mangle -F
ip6tables -t nat -X
ip6tables -t mangle -X
ip6tables -F
ip6tables -X
ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT DROP

#--------- Scan For Vulnerabilities and viruses ----------------
chkrootkit -q
rkhunter --update
rkhunter --propupd
rkhunter -c
lynis -c
freshclam
clamscan -r -i --exclude-dir="^/sys" /
)
fi
exit
