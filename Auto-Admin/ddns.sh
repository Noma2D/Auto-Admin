#!/bin/bash
# $ipnet $mask $ipnetrev $doname $serend $serip $sername $ranstart $ranend
ping_test="8.8.8.8"

ping_output=$(ping -c 1 $ping_test)

compare_ips() {
    local ip1="$1"
    local ip2="$2"
    local base_ip="$3"

    # Разбиваем IP-адреса на октеты
    IFS='.' read -ra ip1_octets <<< "$ip1"
    IFS='.' read -ra ip2_octets <<< "$ip2"
    IFS='.' read -ra base_ip_octets <<< "$base_ip"

    # Проверяем, что IP-адреса имеют 4 октета
    if [[ "${#ip1_octets[@]}" -ne 4 || "${#ip2_octets[@]}" -ne 4 || "${#base_ip_octets[@]}" -ne 4 ]]; then
        echo "Неверный формат IP-адреса"
        return 0
    fi

    local last_nonzero_octet=-1

    # Находим последний октет третьего IP-адреса, который не равен 0
    for i in {0..3}; do
        if [[ "${base_ip_octets[$i]}" -ne 0 ]]; then
            last_nonzero_octet=$i
        else
            break
        fi
    done

    if [[ "$last_nonzero_octet" -eq -1 ]]; then
        return 0
    fi

    # Проверяем равенство октетов до последнего ненулевого октета третьего IP-адреса
    for ((i=0; i < "$last_nonzero_octet"; i++)); do
        if [[ "${base_ip_octets[$i]}" -ne "${ip1_octets[$i]}" ]] || [[ "${base_ip_octets[$i]}" -ne "${ip2_octets[$i]}" ]]; then
            echo "Один из IP-адресов из другой подсети"
            return 0
        fi
    done

    # Сравниваем октеты, начиная с последнего ненулевого октета третьего IP-адреса
    for i in {0..3}; do
        if [[ "${i}" -ge "$last_nonzero_octet" ]]; then
            if [[ "${ip1_octets[$i]}" -lt "${ip2_octets[$i]}" ]]; then
                return 1
            elif [[ "${ip1_octets[$i]}" -gt "${ip2_octets[$i]}" ]]; then
                return 2
	    fi
        fi
    done
    return 0
}


validate_subnet_mask() {
  local subnet_mask="$1"
  local octets=( ${subnet_mask//./ } )  # Разделить маску сети на октеты

  # Проверка, что есть 4 октета
  if [ "${#octets[@]}" -ne 4 ]; then
    echo "Маска сети должна содержать 4 октета" >&2
    return 1
  fi

  # Проверка каждого октета
  for octet in "${octets[@]}"; do
    # Проверка, что октет является целым числом
    if ! [[ "$octet" =~ ^[0-9]+$ ]]; then
      echo "Октет '$octet' не является целым числом" >&2
      return 1
    fi

    # Проверка, что октет находится в диапазоне от 0 до 255
    if ((octet < 0 || octet > 255)); then
      echo "Октет '$octet' находится вне диапазона от 0 до 255" >&2
      return 1
    fi
  done

  # Проверка на правильность маски (последовательность единиц и затем нулей)
  local binary_mask="$(echo "obase=2; ${octets[0]}" | bc)"
  for ((i = 1; i < 4; i++)); do
    binary_mask+="$(echo "obase=2; ${octets[i]}" | bc)"
  done

  if [[ "$binary_mask" =~ ^1*0*$ ]]; then
    return 0  # Маска сети валидна
  else
    echo "Маска сети '$subnet_mask' неправильная" >&2
    return 1
  fi
}


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

ddns(){
source /etc/auto-admin/interfaces.sh
while $true; do
	read -p "Введите желаемый ip-адрес сервера: [$ip_lan] " serip
	if ipvalid $serip; then
		break
  	elif [[ $serip = "" ]]; then
		serip=$ip_lan
		break
	else
		echo "Указан неверный IP-адрес"
    fi
done
serend=$(echo $serip | awk -F. '{print $4}')

while $true; do
	read -p "Введите маску ip-адреса сервера: " mask
	if validate_subnet_mask $mask; then
		break
	fi
done

read -p "Введите имя сервера: " sername
read -p "Введите имя домена для DNS: " doname
serverstart=${serip%.*}.0
while $true; do
	read -p "Введите сеть ip для работы DHCP [$serverstart]: " ipnet
	if ipvalid $ipnet; then
		break
  	elif [[ $ipnet = "" ]]; then
		ipnet=$serverstart
		break
	else
		echo "Указан неверный IP-адрес"
        fi
done
ipnetrev=$(echo $ipnet | awk -F. '{print $4"."$3"."$2"."$1}')
while $true; do
while $true; do
	read -p "Введите первый ip-адрес для сети DHCP: " ranstart
	if ipvalid $ranstart; then
		break
	else
		echo "Указан неверный IP-адрес"
    fi
done
while $true; do
	read -p "Введите последний ip-адрес для сети DHCP: " ranend
	if ipvalid $ranend; then
		break
	else
		echo "Указан неверный IP-адрес"
    fi
done
compare_ips $ranstart $ranend $ipnet
if [ "$?" -eq 1 ]
then
	 break
else
	echo "Последний IP-адрес меньше первого"
	read -p "Хотите поменять их местами? " swapgender
	case $swapgender in
		Y | Yes | Да | Д)
			helper=$ranend
			ranend=$ranstart
			ranstart=$helper
			break
	esac
fi
done

export "ipint=$serip"
export "doname=$doname"
export "servname=$sername"

sudo ip -4 addr flush dev $nic_int
sudo ip -4 addr flush dev $nic_lan
sudo ip link set $nic_int up
sudo dhclient $nic_int
sudo ip link set $nic_lan up
sudo ip addr add $serip/255.255.255.0 dev $nic_lan

echo "# The primary network interface
allow-hotplug $nic_int
iface $nic_int inet dhcp

iface $nic_lan inet static
address $serip
netmask $mask
dbs-servers $serip 8.8.8.8
auto $nic_lan
" | sudo tee -a /etc/network/interfaces >> /dev/null

sudo systemctl restart networking.service
sudo apt update
sudo apt-get install isc-dhcp-server -y
sudo apt-get install bind9 bind9utils bind9-doc dnsutils -y
sudo mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak
sudo mv /etc/bind/named.conf /etc/bind/named.conf.bak
sudo mv /etc/bind/named.conf.options /etc/bind/named.conf.options.bak
sudo touch /etc/bind/named.conf
sudo chmod 666 /etc/bind/named.conf
sudo touch /etc/bind/named.conf.dynamic
sudo chmod 666 /etc/bind/named.conf.dynamic
sudo touch /etc/bind/named.conf.options
sudo chmod 666 /etc/bind/named.conf.options
sudo sed -i "s/127.0.1.1/$serip/g" /etc/hosts
sudo echo "domain $doname" | tee -a /etc/resolv.conf

sudo echo "acl trusted_clients {
	localhost;
	localnets;
	$serip;
};
options {
	directory \"/var/cache/bind\";

	allow-query { trusted_clients; };
	allow-recursion { trusted_clients; };
	recursion yes;

	forwarders {
		$serip;
		8.8.8.8;
		8.8.4.4;
	};

	dnssec-validation auto;
	listen-on { any; };
	listen-on-v6 { none; };
};
" | 	sudo tee -a /etc/bind/named.conf.options >> /dev/null

echo "include \"/etc/bind/ddns.key\";
zone \"$doname\" {
	type master;
	file \"/var/lib/bind/db.$doname\";
	update-policy {
		grant ddns-key zonesub ANY;
	};
};
zone \"$ipnetrev.in-addr.arpa\" {
	type master;
	file \"/var/lib/bind/db.$ipnetrev.in-addr.arpa\";
	update-policy{
		grant ddns-key zonesub ANY;
	};
};" | 	sudo tee -a /etc/bind/named.conf.dynamic >> /dev/null

echo "include \"/etc/bind/named.conf.dynamic\";
include \"/etc/bind/named.conf.options\";" | 	sudo tee -a /etc/bind/named.conf >> /dev/null

sudo touch /etc/bind/ddns.key
sudo chmod 666 /etc/bind/ddns.key
sudo ddns-confgen | 	sudo grep -A3 "key \"ddns-key\"" | tee -a /etc/bind/ddns.key >> /dev/null

sudo touch /var/lib/bind/db.$doname
sudo touch /var/lib/bind/db.$ipnetrev.in-addr.arpa
sudo chmod 666 /var/lib/bind/db.$doname
sudo chmod 666 /var/lib/bind/db.$ipnetrev.in-addr.arpa

sudo echo "\$TTL		604800
@	IN	SOA		$sername.$doname. root.$doname. (
				3			; Serial
				604800		; Refresh
				86400		; Retry
				2419200		; Expire
				604800	)	; Negative Cache TTL
;
@	IN	NS	$sername.$doname.
$sername	IN	A	$serip
" | 	sudo tee -a /var/lib/bind/db.$doname >> /dev/null

sudo echo "\$TTL        604800
@       IN      SOA     $sername.$doname. root.$doname (
                        2               ; Serial
                        604800          ; Refresh
			86400           ; Retry
			2419200         ; Expire
                        604800  )       ; Negative Cache TTL
;
@       IN      NS      $sername.$doname.
$serend		IN		PTR		$sername.$doname
" | 	sudo tee -a /var/lib/bind/db.$ipnetrev.in-addr.arpa >> /dev/null

sudo named-checkconf -z

sudo touch /etc/dhcp/dhcpd.conf
sudo chmod 666 /etc/dhcp/dhcpd.conf

sudo echo "include \"/etc/bind/ddns.key\";
option domain-name \"$doname\";
option domain-name-servers $serip;
zone $doname {
	primary $serip;
	key ddns-key;
}
zone $ipnetrev.in-addr.arpa {
	primary $serip;
	key ddns-key;
}
ddns-updates on;
ddns-update-style standard;
autoritative;
default-lease-time 600;
max-lease-time 7200;
subnet $ipnet netmask $mask {
	range $ranstart $ranend;
	default-lease-time 600;
	max-lease-time 7200;
}" | sudo tee -a /etc/dhcp/dhcpd.conf >> /dev/null

sudo sed -i 's/INTERFACESv4=""/INTERFACESv4="$nic_lan"/g' /etc/default/isc-dhcp-server
restarter=0
while [[ $restarter -lt 5 ]]; do
	sudo rm -rf /var/run/dhcpd.pid >> /dev/null
	sudo systemctl restart isc-dhcp-server
	sudo systemctl restart bind9
	restarter+=1
done
}
if echo $ping_output | grep -q "1 packets transmitted, 1 received"; then
	ddns
else
	echo "У вас нет доступа в сеть Интернет!"
fi
