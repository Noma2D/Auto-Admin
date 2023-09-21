#! /bin/bash
echo "Запущена настройка FireWall. Для получения информации введите help"
sudo cp /etc/iptables.rules /etc/iptables.rules.bak
while $true; do
read -p ">>> " dad
case in dad
  close-all)
    sudo iptables -F
    ;;
  open-in)
    read -p "Введите номер порта: " port
    read -p "Укажите протокол порта [tcp/udp]: " prot
    case in prot
      tcp | TCP)
        sudo iptables -A INPUT -p tcp --dport $port -j ACCEPT
        ;;
      udp | UDP)
        sudo iptables -A INPUT -p udp --dport $port -j ACCEPT
        ;;
    esac
    ;;
  open-out)
    read -p "Введите номер порта: " port
    read -p "Укажите протокол порта [tcp/udp]: " prot
    case in prot
      tcp | TCP)
        sudo iptables -A OUTPUT -p tcp --dport $port -j ACCEPT
        ;;
      udp | UDP)
        sudo iptables -A OUTPUT -p udp --dport $port -j ACCEPT
        ;;
    esac
    ;;
  close-in)
    read -p "Введите номер порта: " port
    read -p "Укажите протокол порта [tcp/udp]: " prot
    case in prot
      tcp | TCP)
        sudo iptables -A INPUT -p tcp --dport $port -j DROP
        ;;
      udp | UDP)
        sudo iptables -A INPUT -p udp --dport $port -j DROP
        ;;
    esac
    ;;
  close-out)
    read -p "Введите номер порта: " port
    read -p "Укажите протокол порта [tcp/udp]: " prot
    case in prot
      tcp | TCP)
        sudo iptables -A OUTPUT -p tcp --dport $port -j DROP
        ;;
      udp | UDP)
        sudo iptables -A OUTPUT -p udp --dport $port -j DROP
        ;;
    esac
    ;;
  basic)
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
    ;;
  show-chages)
    sudo iptables-save > /etc/iptables.rules.changes
    diff -u /etc/iptables.rules.changes /etc/iptables.rules.bak
    ;;
  save-changes)
    sudo iptables-save > /etc/iptables.rules
    ;;
  restore-changes)
    sudo cp /etc/iptables.rules.bak /etc/iptables.rules
    ;;
  help)
    echo" 
    close-all - Закрыть все порты (Сбросить настройки)
    open-in - Открыть приём пакетов на порт
    open-out - Открыть отправку пакетов с порта
    close-in - Закрыть приём пакетов на порт
    close-out - Закрыть отправку пакетов с порта
    basic - Произвести стандартную настройку с часто используемыми портами
    show-changes - Показать различия правил между текущими и предыдущими настройками
    save-changes - Сохранить изменения настроек iptables
    restore-changes - Вернуть настройки к тем, что были изначально
    exit - Выход из утилиты"
    ;;
  *)
    echo "Неизвестная команда, для получения списка команд введите help"
  exit)
    break
    ;;
esac
done
