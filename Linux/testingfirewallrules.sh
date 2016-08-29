sudo apt-get install hping3 -y
#The tool will attempt to ping flood localhost with ip 0.0.0.0 (Firewall test)
sudo hping3 -1 --flood -a localhost 0.0.0.0
