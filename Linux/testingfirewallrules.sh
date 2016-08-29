sudo apt-get install hping3 -y
#The tool will attempt to ping flood localhost with broadcast address 255.255.255.255 (Firewall test)
sudo hping3 -1 --flood -a localhost 255.255.255.255
