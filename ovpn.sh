#! /bin/bash
ping_test="8.8.8.8"
ping_output=$(ping -c 1 $ping_test)
if echo $ping_output | grep -q "1 packets transmitted, 1 received"; then
	eval $(cat values.txt)
	# $ip_mask $nic $uname $uip
	sudo apt install astra-openvpn-server
	sudo astra-openvpn-server start server $ip_mask port 1944 nic $nic
	sudo astra-openvpn-server client $uname
	ssh root@$uip sudo apt install openvpn-server -y
	scp root@$uip:/etc/openvpn/clients_keys/god/* /etc/openvpn/
	ssh root@$uip mv /etc/openvpn/client.ovpn /etc/openvpn/server.conf
	ssh root@$uip sudo systemctl restart openvpn
	rm -rf values.txt
else
	echo "У вас нет доступа в сеть Интернет!"
fi
