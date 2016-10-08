#!/bin/sh
#MIT Licence 
#Copyright (c) Ethan Perry, Andy Lyu
unalias -a #Get rid of aliases
echo "unalias -a" >> ~/.bashrc
echo "unalias -a" >> /root/.bashrc

#--------- Change Root Password ----------------
passwd
echo "Please change other user's passwords too"

#--------- Check and Change UID's of 0 not Owned by Root ----------------
touch /zerouidusers

cut -d: -f1,3 /etc/passwd | egrep ':0$' | cut -d: -f1 | grep -v root > /zerouidusers

if [ -s /zerouidusers ]
then
     echo "There are Zero UID Users! Fix Now!"
else
     echo "No Zero UID Users"
fi


#--------- Allow Only Root Cron ----------------
cd /etc/
/bin/rm -f cron.deny at.deny
echo root >cron.allow
echo root >at.allow
/bin/chown root:root cron.allow at.allow
/bin/chmod 644 cron.allow at.allow

#--------- Securing Apache ----------------
a2enmod userdir

chown -R root:root /etc/apache2
chown -R root:root /etc/apache

if [ -e /etc/apache2/apache2.conf ]; then
	echo "<Directory />" >> /etc/apache2/apache2.conf
	echo "        AllowOverride None" >> /etc/apache2/apache2.conf
	echo "        Order Deny,Allow" >> /etc/apache2/apache2.conf
	echo "        Deny from all" >> /etc/apache2/apache2.conf
	echo "</Directory>" >> /etc/apache2/apache2.conf
	echo "UserDir disabled root" >> /etc/apache2/apache2.conf
fi

systemctl restart apache2.service

#--------- Manual File Inspection ----------------
crontab -e #make sure crontab is empty
cut -d: -f1,3 /etc/passwd | egrep ':[0-9]{4}$' | cut -d: -f1 > listofusers
echo root >> listofusers
nano /etc/apt/sources.list #check for malicious sources
nano /etc/resolv.conf #make sure if safe, use 8.8.8.8 for name server
nano /etc/hosts #make sure is not redirecting
nano /etc/rc.local #should be empty except for 'exit 0'
nano /etc/lightdm/lightdm.conf #allow_guest=false, remove autologin
nano /etc/ssh/sshd_config #PermitRootLogin no, Protocol 2, X11Forwarding no, PermitEmptyPasswards no
nano /etc/sudoers #make sure sudoers file is clean. There should be no NOPASSWD
nano listofusers #No unauthorized users
nano zerouidusers #There should be no one in this. If there is, change the uid of the user

#--------- Manual Network Inspection ----------------
lsof -i -n -P
netstat -tulpn

#--------- Update Using Apt-Get ----------------
#apt-get update --no-allow-insecure-repositories
apt-get update
apt-get dist-upgrade -y
apt-get install -f -y
apt-get autoremove -y
apt-get autoclean -y
apt-get check

#--------- Download programs ----------------
apt-get install -y chkrootkit portsentry ufw sysv-rc-conf nessus clamav rkhunter apparmor apparmor-profiles
apt-get install -y --reinstall coreutils

#This will download lynis 2.3.3, which may be out of date
wget https://cisofy.com/files/lynis-2.3.3.tar.gz -O /lynis.tar.gz
tar -xzf /lynis.tar.gz --directory /usr/share/

#--------- Configure Automatic Updates ----------------
cat /etc/apt/apt.conf.d/10periodic | grep APT::Periodic::Update-Package-Lists | grep 0 >> /dev/null
if [ $?==0 ]; then
	sed -i 's/APT::Periodic::Update-Package-Lists "0"/APT::Periodic::Update-Package-Lists "1"/g' /etc/apt/apt.conf.d/10periodic
fi

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
cd / && ls -laR 2> /dev/null | grep rwxrwxrwx | grep -v "lrwx" &> /tmp/777s
echo "777 Files: "
cat /tmp/777s

#--------- Setup Firewall ----------------
#Please verify that the firewall wont block any services, such as an Email server, when defaulted.
#I will back up iptables for you in and put it in /iptables/rules.v4.bak and /iptables/rules.v6.bak

#Backup
mkdir /iptables/
touch /iptables/rules.v4.bak
touch /iptables/rules.v6.bak
iptables-save > /iptables/rules.v4.bak
ip6tables-save > /iptables/rules.v6.bak

#Uninstall UFW and install iptables
apt-get remove -y ufw
apt-get install -y iptables
apt-get install -y ip6tables
apt-get install -y iptables-persistent
apt-get install -y ipset

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

#Block Bogons
printf "\033[1;31mEnter primary internet interface: \033[0m\n"
read interface

#Blocks bogons going into the computer
iptables -A INPUT -s 127.0.0.0/8 -i $interface -j DROP
iptables -A INPUT -s 0.0.0.0/8 -j DROP
iptables -A INPUT -s 100.64.0.0/10 -j DROP
iptables -A INPUT -s 169.254.0.0/16 -j DROP
iptables -A INPUT -s 192.0.0.0/24 -j DROP
iptables -A INPUT -s 192.0.2.0/24 -j DROP
iptables -A INPUT -s 198.18.0.0/15 -j DROP
iptables -A INPUT -s 198.51.100.0/24 -j DROP
iptables -A INPUT -s 203.0.113.0/24 -j DROP
iptables -A INPUT -s 224.0.0.0/3 -j DROP

#Blocks bogons from leaving the computer
iptables -A OUTPUT -d 127.0.0.0/8 -o $interface -j DROP
iptables -A OUTPUT -d 0.0.0.0/8 -j DROP
iptables -A OUTPUT -d 100.64.0.0/10 -j DROP
iptables -A OUTPUT -d 169.254.0.0/16 -j DROP
iptables -A OUTPUT -d 192.0.0.0/24 -j DROP
iptables -A OUTPUT -d 192.0.2.0/24 -j DROP
iptables -A OUTPUT -d 198.18.0.0/15 -j DROP
iptables -A OUTPUT -d 198.51.100.0/24 -j DROP
iptables -A OUTPUT -d 203.0.113.0/24 -j DROP
iptables -A OUTPUT -d 224.0.0.0/3 -j DROP

#Blocks outbound from source bogons - A bit overkill
iptables -A OUTPUT -s 127.0.0.0/8 -o $interface -j DROP
iptables -A OUTPUT -s 0.0.0.0/8 -j DROP
iptables -A OUTPUT -s 100.64.0.0/10 -j DROP
iptables -A OUTPUT -s 169.254.0.0/16 -j DROP
iptables -A OUTPUT -s 192.0.0.0/24 -j DROP
iptables -A OUTPUT -s 192.0.2.0/24 -j DROP
iptables -A OUTPUT -s 198.18.0.0/15 -j DROP
iptables -A OUTPUT -s 198.51.100.0/24 -j DROP
iptables -A OUTPUT -s 203.0.113.0/24 -j DROP
iptables -A OUTPUT -s 224.0.0.0/3 -j DROP

#Block receiving bogons intended for bogons - Super overkill
iptables -A INPUT -d 127.0.0.0/8 -i $interface -j DROP
iptables -A INPUT -d 0.0.0.0/8 -j DROP
iptables -A INPUT -d 100.64.0.0/10 -j DROP
iptables -A INPUT -d 169.254.0.0/16 -j DROP
iptables -A INPUT -d 192.0.0.0/24 -j DROP
iptables -A INPUT -d 192.0.2.0/24 -j DROP
iptables -A INPUT -d 198.18.0.0/15 -j DROP
iptables -A INPUT -d 198.51.100.0/24 -j DROP
iptables -A INPUT -d 203.0.113.0/24 -j DROP
iptables -A INPUT -d 224.0.0.0/3 -j DROP

iptables -A INPUT -i lo -j ACCEPT

#Allowing ports for mail servers
#iptables -A INPUT -p 25
#iptables -A INPUT -p 2525
#iptables -A INPUT -p 587
#iptables -A INPUT -p 465
#iptables -A INPUT -p 2526

#Least Strict Rules
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

#Strict Rules -- Only allow well known ports (1-1022)
#iptables -A INPUT -p tcp --match multiport --sports 1:1022 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#iptables -A INPUT -p udp --match multiport --sports 1:1022 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -p tcp --match multiport --dports 1:1022 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -p udp --match multiport --dports 1:1022 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o lo -j ACCEPT
#iptables -P OUTPUT DROP

#Very Strict Rules - Only allow HTTP/HTTPS and DNS
#iptables -A INPUT -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#iptables -A INPUT -p tcp --sport 443 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#iptables -A INPUT -p tcp --sport 53 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#iptables -A INPUT -p udp --sport 53 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -p tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -p tcp --dport 53 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -p udp --dport 53 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o lo -j ACCEPT
#iptables -P OUTPUT DROP

mkdir /etc/iptables/
touch /etc/iptables/rules.v4
touch /etc/iptables/rules.v6
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6

#--------- Secure /etc/sysctl.conf ----------------
sysctl -w net.ipv4.tcp_syncookies=1
sysctl -w net.ipv4.ip_forward=0
sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.default.send_redirects=0
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0
sysctl -w net.ipv4.conf.all.secure_redirects=0
sysctl -w net.ipv4.conf.default.secure_redirects=0
sysctl -p

#--------- Scan For Vulnerabilities and viruses ----------------
chkrootkit -q
rkhunter --update
rkhunter --propupd
rkhunter -c --enable all --disable none
/usr/share/lynis/lynis update info
/usr/share/lynis/lynis audit system
systemctl stop clamav-freshclam
freshclam --stdout
systemctl start clamav-freshclam
clamscan -r -i -stdout --exclude-dir="^/sys" /
