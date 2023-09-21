#! /bin/bash
# $uname $uip
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
		read -p "Введите имя пользователя на удалённом хосте: " $uname
		while $true; do
			read -p "Введи ip-адрес удалённого хоста: " uip
			if ipvalid $uip; then
				break
			else
				echo "Указан неверный IP-адрес"
    		fi
		done
		ping_outtest=$(ping -c 1 $uip)
		if echo $ping_outtest | grep -q "1 packets transmitted, 1 received"; then
			read -p "Введите пароль пользователя на удалённом хосте: " passwd
			tput cud1
			sudo apt install sshpass -y
			sshpass -p $passwd ssh $uname@$uip sudo sed -i "s/\#PubkeyAuthentication\ yes/PubkeyAuthentication\ yes/g" /etc/ssh/sshd_config
			sshpass -p $passwd ssh $uname@$uip sudo sed -i "s/\#PermitRootLogin\ prohibit-password/PermitRootLogin\ yes/g" /etc/ssh/sshd_config;sudo systemctl restart sshd
			sshpass -p $passwd ssh $uname@$uip sudo systemctl restart sshd
			sudo ssh-keygen -t rsa -N "" -f serv.key
			sudo ssh-copy-id $uip
			ssh root@$uip
			ssh root@$uip
		else
			echo "Нет доступа до удалённого хоста"
			read -p "Ввести другой IP-адрес? " answ
			case $answ in
				Yes | Да | Y | Д)
            	  ;;
            	No| Нет | N | Н)
            	  break
            	  ;;
			esac
		fi
	done
else
	echo "У вас нет доступа в сеть Интернет!"
fi
