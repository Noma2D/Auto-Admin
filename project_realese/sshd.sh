#! /bin/bash
# $uname $uip $passwd
i1=1
count=1
ping_test="8.8.8.8"
ping_output=$(ping -c 1 $ping_test)
if echo $ping_output | grep -q "1 packets transmitted, 1 received"
then
	eval $(cat values.txt)
	if ping -c 1 $uip
	then
		sudo apt install sshpass -y
		sudo sshpass -p $passwd ssh $uname@$uip sudo sed -i "s/\#\PubkeyAuthentication\ yes/PubkeyAuthentication\ yes/" /etc/ssh/sshd_config
		sudo sshpass -p $passwd ssh $uname@$uip sudo sed -i "s/\#\PermitRootLogin\ prohibit-password/PermitRootLogin\ yes/" /etc/ssh/sshd_config
		sudo sshpass -p $passwd ssh $uname@$uip sudo systemctl restart sshd
		sudo ssh-keygen -t rsa -N "" -f $HOME/.ssh/id_rsa
		sudo ssh-copy-id $uname@$uip
		while [ $i1 -eq 1 ]
		do
			sudo sshpass -p $passwd ssh $uname@$uip sudo sed -i "s/\#\PubkeyAuthentication\ yes/PubkeyAuthentication\ yes/" /etc/ssh/sshd_config
                	sudo sshpass -p $passwd ssh $uname@$uip sudo sed -i "s/\#\PermitRootLogin\ prohibit-password/PermitRootLogin\ yes/" /etc/ssh/sshd_config
                	sudo sshpass -p $passwd ssh $uname@$uip sudo systemctl restart sshd
			count=[$count+1]
			if sudo ssh-copy-id root@$uip
			then
				break
			fi
			if [$count -eq 5]
			then 
				break
			fi
		done
		sudo ssh-copy-id root@$uip
		rm -rf values.txt
	else
		echo "Нет доступа до клиента"
	fi
else
	echo "У вас нет доступа в сеть Интернет!"
fi
