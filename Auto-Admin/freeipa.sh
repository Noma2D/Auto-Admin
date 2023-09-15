#!/bin/bash
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

ipainstall() {
read -p "Введите имя домена: " domain
read -p "Введите имя сервера: " servname
while $true; do
	read -p "Введите IP-адрес интерфейса: " $ipint
	if ipvalid $ipint; then
		break
	else
		echo "Указан неверный IP-адрес"
	fi
done
read -p -s "Введите пароль учётной записи администратора: " passwd
read -p "Включить поддержку SMB? [Y/N]" smb
case $smb in
	Y | Yes | Да | Д | y | yes | д | да)
		astra-freeipa-server -d $domain -n $servername -ip $ipint -p $passwd --dogtag -s -y
		;;
	N | No | n | no | Нет | Н | н | нет)
		astra-freeipa-server -d $domain -n $servername -ip $ipint -p $passwd --dogtag -y
		;;
esac
}

source /etc/auto-admin/ddns.sh
echo $doname
echo $servname
echo $ipint
ping_test="8.8.8.8"
ping_output=$(ping -c 1 $ping_test)

if echo $ping_output | grep -q "1 packets transmitted, 1 received"; then
	sudo apt install astra-freeipa-server -y
	if [[ "$doname" != "" ]]; then
		read -p "На сервере уже установлен DDNS, хотите использовать его параментры? [Y/N]" answ
		case $answ in
			Y | Yes | Да | Д | y | yes | д | да)
				read -p -s "Введите пароль учётной записи администратора: " passwd
				read -p "Включить поддержку SMB? [Y/N]" smb
				case $smb in
				       Y | Yes | Да | Д | y | yes | д | да)
        			         astra-freeipa-server -d $doname -n $servname -ip $ipint -p $passwd --dogtag -s -y
			                 ;;
 				       N | No | n | no | Нет | Н | н | нет)
  			        	 astra-freeipa-server -d $doname -n $servname -ip $ipint -p $passwd --dogtag -y
        			         ;;
				esac
				;;
			N | No | n | no | Нет | Н | н | нет)
				ipainstall
				;;
		esac
	else
		ipainstall
	fi
else
	echo "У вас нет доступа в интернет!"
fi

