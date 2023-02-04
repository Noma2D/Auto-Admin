#!/bin/bash
eval $(cat intface.txt)
sudo ip -4 addr flush dev $nic_int
sudo ip -4 addr flush dev $nic_lan
sudo ip link set $nic_int up
sudo dhclient $nic_int
sudo ip link set $nic_lan up
sudo ip addr add 192.168.10.2/255.255.255.0 broadcast 192.168.10.255 dev $nic_lan
