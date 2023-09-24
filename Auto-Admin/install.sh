#!/bin/bash

#unzip Auto-Admin $HOME/Auto-Admin
sudo mkdir /etc/auto-admin/
sudo cp $HOME/Auto-Admin/*.sh /etc/auto-admin
sudo cp $HOME/Auto-Admin/Auto-Admin /usr/bin/
echo 'export PATH=\"\$HOME/bin:\$PATH\"' | tee -a ~/.bashrc
chmod +x /etc/auto-admin/*
chmod +x /usr/bin/Auto-Admin
source ~/.bashrc
if Auto-Admin
then
    rm -rf $HOME/Auto-Admin
    echo "Установка завершена"
else
    echo "Установка завершилась с ошибкой"
fi
