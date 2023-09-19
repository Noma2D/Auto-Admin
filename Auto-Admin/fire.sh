#! /bin/bash
echo "Запущена настройка FireWall. Для получения информации введите help"
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
  help)
    echo" 
    close-all - Закрыть все порты (Сбросить настройки)
    open-in - Открыть приём пакетов на порт
    open-out - Открыть отправку пакетов с порта
    close-in - Закрыть приём пакетов на порт
    close-out - Закрыть отправку пакетов с порта
    basic - Произвести стандартную настройку с часто используемыми портами
    exit - выход из утилиты"
    ;;
  *)
    echo "Неизвестная команда, для получения списка команд введите help"
  exit)
    break
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
done
sudo iptables-save > /etc/iptables.rules
