#!/bin/bash

eval $(cat intface.txt)
sudo sed -i '9,$d' /etc/network/interfaces
echo "# The primary network interface
allow-hotplug $nic_int
iface $nic_int inet dhcp
auto $nic_int

iface $nic_lan inet static
address 192.168.10.1
netmask 255.255.255.0
dns-servers 192.168.10.1 8.8.8.8
dns-nameservers 192.168.10.1
auto $nic_lan" | tee -a /etc/network/interfaces
sudo systemctl restart networking.service
