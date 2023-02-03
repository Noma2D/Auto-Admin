#! /bin/bash
# $uname $uip
ping_test="8.8.8.8"
ping_output=$(ping -c 1 $ping_test)
if echo $ping_output | grep -q "1 packets transmitted, 1 received"; then
	eval $(cat values.txt)
	apt install sshpass -y
	sshpass -p 1 ssh $uname@$uip sudo sed -i "s/\#PubkeyAuthentication\ yes/PubkeyAuthentication\ yes/g" /etc/ssh/sshd_config
	sshpass -p 1 ssh $uname@$uip sudo sed -i "s/\#PermitRootLogin\ prohibit-password/PermitRootLogin\ yes/g" /etc/ssh/sshd_config;sudo systemctl restart sshd
	sshpass -p 1 ssh $uname@$uip sudo systemctl restart sshd
	sudo ssh-keygen -t rsa -N "" -f serv.key
	sudo ssh-copy-id $uip
	ssh root@$uip
	rm -rf values.txt
else
	echo "У вас нет доступа в сеть Интернет!"
fi
