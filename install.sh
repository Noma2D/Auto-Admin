#!/bin/bash

sudo mkdir /etc/auto-admin/
sudo cp Auto-Admin/*.sh /etc/auto-admin
sudo cp Auto-Admin/Auto-Admin /usr/bin/
echo 'export PATH=\"\$HOME/bin:\$PATH\"' | tee -a ~/.bashrc > /dev/null
sudo chmod +x /etc/auto-admin/*
sudo chmod +x /usr/bin/Auto-Admin
source ~/.bashrc

if command -v Auto-Admin >/dev/null; then
    echo "Установка завершена"
else
    echo "Установка завершилась с ошибкой"
fi
