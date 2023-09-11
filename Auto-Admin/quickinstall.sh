#!/bin/bash
echo "Добро пожаловать в функцию быстрой установки утилит. 
Для получения списка доступных утилит введите команду list"
while $true; do
    read -p ">>>>" name
    case $name in
        Nginx)
          sudo apt install nginx -y
          ;;
        MySQL)
          sudo apt install mysql-server -y
          ;;
        Ansible)
          sudo apt install ansible -y
          ;;
        rsync)
          sudo apt install rsync -y
          ;;
        Docker)
          sudo apt install docker docker-compose -y  
          ;;
        Zabbix)
          sudo apt install zabbix-agent -y
          ;;
        list)
          echo "Список доступных утилит для установки:
          Nginx - Веб-сервер.
          MySQL - Сервер базы данных.
          Ansible - Утилита удалённой развёртки кода.
          rsync - Утилита синхронизации.
          Docker - Утилита контейнеризации.
          Zabbix - Утилита мониторинга системы и сети."
          ;;
        exit)
          break
          ;;
    esac
done