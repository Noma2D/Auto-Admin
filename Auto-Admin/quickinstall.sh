#!/bin/bash

LOG_FILE="/var/log/install_tools.log"

check_package() {
    dpkg -l | grep -q "^ii  $1"
}

install_package() {
    if check_package "$1"; then
        echo "✅ Утилита '$1' уже установлена."
        echo "$(date): Утилита '$1' уже установлена." >> "$LOG_FILE"
    else
        echo "📦 Установка '$1'..."
        apt install -y "$1" &>> "$LOG_FILE"
        if check_package "$1"; then
            echo "✅ Успешно установлена '$1'."
            echo "$(date): Успешно установлена '$1'." >> "$LOG_FILE"
            echo "🔍 Версия:"
            "$2" --version 2>/dev/null || "$2" -v 2>/dev/null || echo "Версия не указана."
        else
            echo "❌ Ошибка при установке '$1'."
            echo "$(date): Ошибка при установке '$1'." >> "$LOG_FILE"
        fi
    fi
}

echo "Выберите утилиту для установки:
1) Nginx - веб-сервер с поддержкой обратного прокси и HTTPS
2) Apache - популярный веб-сервер для работы с CMS
3) Bind9 - DNS-сервер для управления доменными зонами
4) ISC DHCP Server - сервер для автоматической раздачи IP-адресов
5) WireGuard - быстрый и безопасный VPN-сервис
6) OpenVPN - мощный инструмент для настройки VPN-туннелей
7) FreeIPA - система для централизованного управления пользователями
8) Samba - сервис для доступа к сетевым папкам с Windows-клиентов
9) Squid - прокси-сервер с поддержкой кеширования и фильтрации
10) iptables - утилита для настройки межсетевого экрана
11) Logrotate — утилита для автоматического управления и архивации лог-файлов
12) Fail2Ban — защита сервисов (например, SSH) от брутфорс-атак путём автоматической блокировки IP-адресов
13) Certbot — инструмент для автоматической установки и обновления SSL-сертификатов Let's Encrypt
14) Net-tools — набор классических сетевых утилит (ifconfig, netstat и др.) для диагностики сетевых подключений
15) Iptables-persistent — плагин для сохранения правил iptables между перезагрузками системы
16) MTR (My Traceroute) — продвинутая версия traceroute, удобная для диагностики сетевых проблем в реальном времени
17) Tcpdump — мощная утилита для перехвата и анализа сетевого трафика
18) Glances — инструмент для мониторинга системных ресурсов (ЦП, память, диски, сеть) в реальном времени
19) rkhunter (Rootkit Hunter) — сканер для поиска руткитов и вредоносного ПО на сервере
20) Sysstat — набор инструментов для мониторинга производительности системы (например, iostat, mpstat, pidstat)
"

while $true; do
  read -p "Введите номер утилиты (или несколько номеров через пробел): " choices
  for choice in $choices; do
      case $choice in
          1) install_package "nginx" "nginx" ;;
          2) install_package "apache2" "apache2" ;;
          3) install_package "bind9" "named" ;;
          4) install_package "isc-dhcp-server" "dhcpd" ;;
          5) install_package "wireguard" "wg" ;;
          6) install_package "openvpn" "openvpn" ;;
          7) install_package "freeipa-server" "ipa-server" ;;
          8) install_package "samba" "smbd" ;;
          9) install_package "squid" "squid" ;;
          10) install_package "iptables" "iptables" ;;
          11) install_package "logrotate" "logrotate" ;;
          12) install_package "fail2ban" "fail2ban" ;;
          13) install_package "certbot" "certbot" ;;
          14) install_package "net-tools" "ifconfig" ;;
          15) install_package "iptables-persistent" "iptables-save" ;;
          16) install_package "mtr" "mtr" ;;
          17) install_package "tcpdump" "tcpdump" ;;
          18) install_package "glances" "glances" ;;
          19) install_package "rkhunter" "rkhunter" ;;
          20) install_package "sysstat" "iostat" ;;
          exit) break ;;
          *) echo "❌ Неверный выбор: $choice" ;;
      esac
  done
  echo "✅ Установка завершена. Лог записан в $LOG_FILE"
done