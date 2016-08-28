#!/bin/sh

#--------- Manual File Inspection ----------------
nano /etc/apt/sources.list #check for malicious sources
nano /etc/resolv.conf #make sure if safe, use 8.8.8.8 for name server
nano /etc/hosts #make sure is not redirecting
nano /etc/rc.local #should be empty except for 'exit 0'
nano /etc/sysctl.conf #change net.ipv4.tcp_syncookies entry from 0 to 1
nano /etc/lightdm/lightdm.conf #allow_guest=false, remove autologin
nano /etc/ssh/sshd_config #Look for PermitRootLogin and set to no

#--------- Manual Network Inspection ----------------
lsof  -i -n -P
netstat -tulpn

#--------- Update Using Apt-Get ----------------
apt-get update --no-allow-insecure-repositories; apt-get dist-upgrade -y; apt-get install -f -y; apt-get autoremove -y; apt-get autoclean -y; apt-get check

#--------- Download programs ----------------
apt-get install  -y firefox hardinfo chkrootkit iptables portsentry lynis ufw sysv-rc-conf nessus clamav
apt-get install  -y --reinstall coreutils

#--------- Find Dangerous Files ----------------
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

#--------- Scan For Vulnerabilities and viruses ----------------
chkrootkit -q
lynis -c
freshclam
clamscan -r -i --exclude-dir="^/sys" /
