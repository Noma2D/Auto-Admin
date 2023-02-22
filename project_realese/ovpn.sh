#! /bin/bash
ping_test="8.8.8.8"
ping_output=$(ping -c 1 $ping_test)
if echo $ping_output | grep -q "1 packets transmitted, 1 received"; then
	eval $(cat values.txt)
	eval $(cat intface.txt)
	# $ip_mask $nic_lan $uname $uip
	echo "Интерфейс $nic_lan"
	if ping -c 1 $uip
	then
		sudo apt install astra-openvpn-server -y
		sudo astra-openvpn-server start port 1944 nic $nic_lan
		sudo sed -i "s/server\ 10.8.0.0/server\ $ip_mask/g" /etc/openvpn/server.conf
		sudo systemctl restart openvpn
		sudo astra-openvpn-server client $uname
		ssh root@$uip sudo apt install openvpn -y
		scp /etc/openvpn/clients_keys/god/* root@$uip:/etc/openvpn/
		ssh root@$uip mv /etc/openvpn/client.ovpn /etc/openvpn/server.conf
		ssh root@$uip sudo systemctl restart openvpn
		rm -rf values.txt
	else
		echo "Нет доступа до клиента"
	fi
else
	echo "У вас нет доступа в сеть Интернет!"
fi
