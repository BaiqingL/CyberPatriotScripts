#!/bin/sh

#--------- Manual File Inspection ----------------
sudo nano /etc/apt/sources.list #check for malicious sources
sudo nano /etc/resolv.conf #make sure if safe, use 8.8.8.8 for name server
sudo nano /etc/hosts #make sure is not redirecting
sudo nano /etc/rc.local #should be empty except for 'exit 0'
sudo nano /etc/sysctl.conf #change net.ipv4.tcp_syncookies entry from 0 to 1
sudo nano /etc/lightdm/lightdm.conf #allow_guest=false, remove autologin
sudo nano /etc/ssh/sshd_config #Look for PermitRootLogin and set to no

#--------- Manual Network Inspection ----------------
sudo lsof  -i -n -P
sudo netstat -tulpn

#--------- Update Using Apt-Get ----------------
sudo apt-get update --no-allow-insecure-repositories; sudo apt-get dist-upgrade -y; sudo apt-get install -f -y; sudo apt-get autoremove -y; sudo apt-get autoclean -y; sudo apt-get check

#--------- Download programs ----------------
sudo apt-get install  -y firefox hardinfo chkrootkit iptables portsentry lynis ufw sysv-rc-conf nessus clamav
sudo apt-get install  -y --reinstall coreutils

#--------- Find Dangerous Files ----------------
sudo find / -name '*.mp3' -type f -delete
sudo find / -name '*.mov' -type f -delete
sudo find / -name '*.mp4' -type f -delete
sudo find / -name '*.avi' -type f -delete
sudo find / -name '*.mpg' -type f -delete
sudo find / -name '*.mpeg' -type f -delete
sudo find / -name '*.flac' -type f -delete
sudo find / -name '*.m4a' -type f -delete
sudo find / -name '*.flv' -type f -delete
sudo find / -name '*.ogg' -type f -delete
sudo find /home -name '*.gif' -type f -delete
sudo find /home -name '*.png' -type f -delete
sudo find /home -name '*.jpg' -type f -delete
sudo find /home -name '*.jpeg' -type f -delete

#--------- Scan For Vulnerabilities and viruses ----------------
sudo chkrootkit -q
sudo lynis -c
sudo freshclam
sudo clamscan -r -i --exclude-dir="^/sys" /
