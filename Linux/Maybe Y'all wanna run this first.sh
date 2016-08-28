#!/bin/sh
cd ~
wget https://cisofy.com/files/lynis-2.3.3.tar.gz
#yo whadup dawg
sudo apt-get update && sudo apt-get dist-upgrade -y && sudo apt install apparmor-profiles && sudo apt-get install ufw && sudo apt-get install iptables && sudo ufw allow ssh && sudo ufw allow http && sudo ufw enable && sudo echo "tmpfs     /dev/shm     tmpfs     defaults,noexec,nosuid     0     0" >> /etc/fstab
sudo echo -e "Port 4200\nProtocol 2\nHostKey /etc/ssh/ssh_host_rsa_key\nHostKey /etc/ssh/ssh_host_dsa_key\nHostKey /etc/ssh/ssh_host_ecdsa_key\nHostKey /etc/ssh/ssh_host_ed25519_key\nUsePrivilegeSeparation yes\nKeyRegenerationInterval 3600\nServerKeyBits 1024\nSyslogFacility AUTH\nLogLevel INFO\nLoginGraceTime 30\nPermitRootLogin no\nDebianBanner no\nStrictModes yes\nRSAAuthentication yes\nPubkeyAuthentication yes\nIgnoreRhosts yes\nRhostsRSAAuthentication no\nHostbasedAuthentication no\nPermitEmptyPasswords no\nChallengeResponseAuthentication no\nX11Forwarding yes\nX11DisplayOffset 10\nPrintMotd no\nPrintLastLog yes\nTCPKeepAlive yes\nAcceptEnv LANG LC_*\nSubsystem sftp /usr/lib/openssh/sftp-server\nUsePAM yes" > /etc/ssh/sshd_config
sudo /etc/init.d/ssh restart
sudo apt-get install apparmor apparmor-profiles tiger && sudo tiger
sudo apt-get install rkhunter chkrootkit && sudo chkrootkit && sudo rkhunter --update && sudo rkhunter --propupd && sudo rkhunter --check
