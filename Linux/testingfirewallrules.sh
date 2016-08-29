sudo apt-get install hping3 -y
#Normal ping
hping3 -1 -c 1 localhost
#SYN Port 0
hping3 -S -c 1 -s 5151 localhost
#FIN flag Port 0
hping3 -F -c 1 -s 5151 localhost
#SYN Port 80
hping3 -S -c 1 -s 5151 -p 80 localhost
#ACK Port 80
hping3 -A -c 1 -s 5151 -p 80 localhost
#UDP Port 80
hping3 -2 -c 1 -s 5151 -p 80 localhost
#The tool will attempt to ping flood localhost with broadcast address 255.255.255.255 (Firewall test)
sudo hping3 -1 --flood -a localhost 255.255.255.255
sleep 10
kill $PID
