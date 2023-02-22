#! /bin/bash
sleep 0.5
sudo apt autoremove isc-dhcp-server -y
sleep 0.5
sudo apt autoremove bind9 bind9utils bind9doc dnsutils -y
sleep 0.5
sudo apt autoremove astra-openvpn-server -y
sleep 0.5
sudo apt autoremove openssh-server -y

sleep 0.5
rm -rf /etc/bind/
sleep 0.5
rm -rf /etc/dhcp/
sleep 0.5
rm -rf /etc/openvpn/
sleep 0.5
rm -rf /var/lib/bind/
sleep 0.5
rm -rf /etc/ssh/

echo "Вы удалили все серверные функции!"

