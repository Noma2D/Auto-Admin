#!/bin/bash

services=(isc-dhcp-server bind9 openvpn nginx mysqld ansible zabbix rsync docker ipa)
tput sc
while $true; do
	echo "Список служб и их состояние:"
	for service in ${services[@]}; do
		sudo systemctl list-units --type=service --all | awk '{print $1, $3}' | tail -n +2 | grep $service
	done
	echo ""
	tput cuu1
	tput el
	if read -t 5 -p '>>> ' input
	then
		if [[ "$input" == "exit" ]]; then
			exit
		fi
	fi
	tput rc
done
