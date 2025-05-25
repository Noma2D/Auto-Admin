#! /bin/bash
ping_test="8.8.8.8"
ping_output=$(ping -c 1 $ping_test)

ipvalid() {
  local ip=${1:-NO_IP_PROVIDED}
  local IFS=.; local -a a=($ip)
  [[ $ip =~ ^[0-9]+(\.[0-9]+){3}$ ]] || return 1
  local quad
  for quad in {0..3}; do
    [[ "${a[$quad]}" -gt 255 ]] && return 1
  done
  return 0
}

if echo $ping_output | grep -q "1 packets transmitted, 1 received"; then
	while $true; do
		read -p "Введи ip подсети для VPN-туннеля (в формате AAA.BBB.CCC.0): " ip_mask
		if ipvalid $ip_mask; then
			break
		else
			echo "Указан неверный IP-адрес"
    	fi
	done
	read -p "Введите имя пользователя на удалённом хосте: " uname
	while $true; do
		read -p "Введи ip-адрес удалённого хоста: " uip
		if ipvalid $uip; then
			break
		else
			echo "Указан неверный IP-адрес"
    	fi
	done
	source interfaces.sh
	# $ip_mask $nic $uname $uip
	sudo apt install astra-openvpn-server
	sudo astra-openvpn-server start port 1944 nic $nic_lan
	sudo sed -i "s/server\ 10.8.0.0/server\ $ip_mask"
	sudo systemctl restart openvpn
	sudo astra-openvpn-server client $uname
	ssh root@$uip sudo apt install openvpn -y
	scp /etc/openvpn/clients_keys/god/* root@$uip:/etc/openvpn/
	ssh root@$uip mv /etc/openvpn/client.ovpn /etc/openvpn/server.conf
	ssh root@$uip sudo systemctl restart openvpn
else
	echo "У вас нет доступа в сеть Интернет!"
fi
