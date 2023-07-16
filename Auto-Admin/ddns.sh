#!/bin/bash
# $ipnet $mask $ipnetrev $doname $serend $serip $sername $ranstart $ranend
ping_test="8.8.8.8"

ping_output=$(ping -c 1 $ping_test)
ddns (){
source /home/prod/PAS-os-main/interfaces.sh
read -p "Введите желаемый ip-адрес сервера: [$ip_lan] " serip
case $serip in
  "")
    serip=$ip_lan
    ;;
  *)
    ;;
esac
serend=$(echo $serip | awk -F. '{print $4}')
read -p "Введите маску ip-адреса сервера: " mask
read -p "Введите имя сервера: " sername
read -p "Введите имя домена для DNS: " doname
read -p "Введите сеть ip для работы DHCP (В формате AAA.BBB.CCC.0): " ipnet
ipnetrev=$(echo $ip_net | awk -F. '{print $4"."$3"."$2"."$1}') 
read -p "Введите первый ip-адрес для сети DHCP: " ranstart
reap -p "Введите последний ip-адрес для сети DHCP: " ranend


sudo ip -4 addr flush dev $nic_int
sudo ip -4 addr flush dev $nic_lan
sudo ip link set $nic_int up
sudo dhclient $nic_int
sudo ip link set $nic_lan up
sudo ip addr add $serip/255.255.255.0 dev $nic_lan

echo "\# The primary network interface
allow-hotplug $nic_int
iface $nic_int inet dhcp

iface $nic_lan inet static
address $serip
netmask $mask
dbs-servers $serip 8.8.8.8
auto $nic_lan
" | sudo tee -a /etc/network/interfaces

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
" | 	sudo tee -a /etc/bind/named.conf.options

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
};" | 	sudo tee -a /etc/bind/named.conf.dynamic

echo "include \"/etc/bind/named.conf.dynamic\";
include \"/etc/bind/named.conf.options\";" | 	sudo tee -a /etc/bind/named.conf

sudo touch /etc/bind/ddns.key
sudo chmod 666 /etc/bind/ddns.key
sudo ddns-confgen | 	sudo grep -A3 "key \"ddns-key\"" | tee -a /etc/bind/ddns.key

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
" | 	sudo tee -a /var/lib/bind/db.$doname

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
" | 	sudo tee -a /var/lib/bind/db.$ipnetrev.in-addr.arpa

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
}" | sudo tee -a /etc/dhcp/dhcpd.conf

sudo sed -i 's/INTERFACESv4=""/INTERFACESv4="$nic"/g' /etc/default/isc-dhcp-server

sudo systemctl restart isc-dhcp-server
sudo systemctl restart bind9
}
if echo $ping_output | grep -q "1 packets transmitted, 1 received"; then
	ddns
else
	echo "У вас нет доступа в сеть Интернет!"
fi
