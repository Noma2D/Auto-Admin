#!/bin/bash
folder=$(pwd)
sudo mkdir /etc/auto-admin/
sudo cp $folder/Auto-Admin/*.sh /etc/auto-admin
sudo cp $folder/Auto-Admin/Auto-Admin /usr/bin/
sudo chmod +x /etc/auto-admin/*
sudo chmod +x /usr/bin/Auto-Admin


if command -v Auto-Admin >/dev/null; then
    echo "Установка завершена"
else
    echo "Установка завершилась с ошибкой"
fi
