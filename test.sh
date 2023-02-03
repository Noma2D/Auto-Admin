#! /bin/bash
# $doname
ping_test="8.8.8.8"
ping_output=$(ping -c 1 $ping_test)
if echo $ping_output | grep -q "1 packets transmitted, 1 received"; then
	eval $(cat values.txt)
	sudo apt install nginx -y
	sudo touch /etc/nginx/conf.d/$doname
	sudo rm -rf values.txt
else
	echo "У вас нет доступа в сеть Интернет!"
fi
