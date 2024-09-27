```
sudo apt update
```
```
sudo apt install -y autoconf gcc libc6 make wget unzip apache2 apache2-utils php libgd-dev
```
```
sudo apt install openssl libssl-dev
```
```
cd /tmp  
wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.14.tar.gz  
tar xzf nagioscore.tar.gz
```
```
cd /tmp/nagioscore-nagios-4.4.14/  
./configure --with-httpd-conf=/etc/apache2/sites-enabled  
make all
```
