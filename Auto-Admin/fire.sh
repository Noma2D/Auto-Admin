#! /bin/bash

#Функции
add() {
  read -p "Разрешить или запретить? [allow/deny] " alny
  read -p "Входящий или исходящий трафик? [in/out] " iut
  echo "Введите номер порта или имя службы "
  read -p "[Пример: OpenSSH, 22 или 22/tcp ] " port
  sudo ufw $alny $iut $port
}
delete() {
  read -p "Разрешающее или запрещающее правило? [allow/deny]" alny
  read -p "Входящий или исходящий трафик? [in/out] " iut
  echo "Введите номер порта или имя службы "
  read -p "[Пример: OpenSSH, 22 или 22/tcp ] " port
  sudo ufw delete $alny $iut $port
}


if command -v sudo ufw &> /dev/null
then
  sleep 0.001
else
  echo "Производиться установка утилиты настройки FireWall - ufw"
  sleep 1
  sudo apt install ufw -y
  echo ""
fi
echo "Запущена настройка FireWall. Для получения информации о командах введите help."
sudo ufw enable > /dev/null
echo "FireWall включен и добавлен в автозагрузку"
while $true; do
read -p ">>> " answ
case $answ in
  add-rule)
    add
    ;;
  del-rule)
    delete
    ;;
  reset)
    sudo ufw reset
    ;;
  log)
    read -p "Включить логирование ufw? [Y/N] " logyn
    case $logyn in
      Y | Yes | Да | Д)
        read -p "Укажите уровень логирования [low/medium/high] " loglvl
        case $loglvl in
          L* | l*)
            sudo ufw logging low
            ;;
          M* | m*)
            sudo ufw logging medium
            ;;
          H* | h*)
            sudo ufw logging high
            ;;
        esac
        ;;
    esac
    ;;
  disable)
    sudo ufw disable
    ;;
  status)
    sudo ufw status verbose
    echo ""
    sleep 1
    echo "Недавно добавленные правила"
    sudo ufw show added 
    ;;
  basic)
    sudo ufw allow in 22/tcp
    sudo ufw allow in 80/tcp
    sudo ufw allow in 443/tcp
    sudo ufw allow in 1944/tcp
    sudo ufw allow in 8080/tcp
    echo "Открыт 22 порт"
    echo "Открыт 80 порт"
    echo "Открыт 443 порт"
    echo "Открыт 1944 порт"
    echo "Открыт 8080 порт"
    ;;
  list)
    sudo ufw app list | sed 's/Available applications:/Доступные утилиты:/'
    ;;
  standart)
    echo "Стандартные значения портов для популярных утилит:
    FTP - 21
    SSH - 22
    Telnet - 23
    SMTP - 25
    DNS -53
    DHCP - 67, 68
    HTTP - 80
    Kerberos - 88
    NTP - 123
    NetBIOS - 137
    SMB-Samba - 139
    HTTPS - 443
    Syslogd - 514
    ldap - 636
    rsync - 873
    OpenVPN - 1194
    MySQL - 3306
    "
    ;;
  enable)
    sudo ufw enable | sed 's/Firewall is active and enabled on system startup/Firewall активен и включен в автозапуске системы/'
    ;;
  disable)
    sudo ufw disable | sed 's/Firewall stopped and disabled on system startup/Firewall остановлен и отключен в автозапуске системы'
    ;;
  help)
    echo "Список команд и возможностей настройки FireWall:
    add-rule - Добавить правило
    del-rule - Удалить правило
    log - Настройка логирования
    basic - Применить базовые настройки и правила
    list - Вывод списка утилит, для которых можно применить настройки FireWall
    status - Вывод статуса FireWall и его настроек
    enable - Включить Firewall
    disable - Отключить Firewall
    standart - Вывод списка всех базовых портов и утилит, работающих на них
    exit - Выход из утилиты"
    ;;
  exit)
    break
    ;;
  *)
    echo "Неизвестная команда, для получения списка команд введите help"
    ;;
esac
done
