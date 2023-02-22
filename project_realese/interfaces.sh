#!/bin/bash

nic_int=`ip route | grep -E '^default via' | awk '{print $5}'`
ip_int=`ip route | grep -E "$nic_int" | grep -v '^default via'  | awk '{print $9}'`
ip1=`ip route | grep -v "$nic_int" `
nic1=`ip route | grep -v "$nic_int"`

ip_lan=`echo "$ip1" | grep -v "tun0" |  awk '{print $9}'`
nic_lan=`echo "$nic1"| grep -v "tun0"  | awk '{print $3}'`

echo "ip_int=$ip_int" | tee -a intface.txt > /dev/null
echo "nic_int=$nic_int" | tee -a intface.txt > /dev/null
echo "ip_lan=$ip_lan" | tee -a intface.txt > /dev/null
echo "nic_lan=$nic_lan" | tee -a  intface.txt > /dev/null

