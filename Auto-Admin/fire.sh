#! /bin/bash
sudo iptables -F
echo "Закрыты все порты"
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
echo "Открыт 22 порт"
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
echo "Открыт 80 порт"
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
echo "Открыт 443 порт"
sudo iptables -A INPUT -p tcp --dport 1944 -j ACCEPT
echo "Открыт 1944 порт"
sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
echo "Открыт 8080 порт"
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -j DROP
echo "Запрет на все не авторизованные входящие соединения"

sudo iptables-save > /etc/iptables.rules