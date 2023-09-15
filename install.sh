#!/bin/bash
folder=$(pwd)
if ls $folder | grep "install.sh" >> /dev/null; then
	sudo mkdir /etc/auto-admin/ 2> /dev/null
	sudo cp Auto-Admin/*.sh /etc/auto-admin
	sudo cp Auto-Admin/Auto-Admin /usr/bin/
	sudo chmod +x /etc/auto-admin/*
	sudo chmod +x /usr/bin/Auto-Admin
else
	echo "Запускать скрипт необходимо находясь в папке со всеми файлами и скриптом install.sh"
fi

if command -v Auto-Admin >/dev/null; then
    echo "Установка завершена"
else
    echo "Установка завершилась с ошибкой"
fi
