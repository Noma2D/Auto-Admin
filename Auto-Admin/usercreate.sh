#!/bin/bash
username=""
while $true; do
read -p "Введите Имя пользователя [Administrator] " username
case $username in
  "")
    username="Administrator"
    ;;
esac

if id "$username" > /dev/null 2>&1; then
  echo "Данный пользователь уже существует"
else
  break 
fi
done
read -p "Введите пароль пользователя $username " password

read -p "Пользователь администратор? [Yes/No] " system
case $system in
  Yes | Да | Y)
    sudo useradd -r -m -p $password $username
    ;;
  No | Нет | N)
    sudo useradd -m -p $password $username
    ;;
esac

if id "$username" > /dev/null 2>&1; then
  echo "Пользователь создан"
else
  echo "Создание пользователя не удалось"
fi

read -p "Добавить пользователя в группу? [Yes/No] " grop
case $grop in
  Yes | Да | Y)
    while $true; do
    read -p "Введите имя группы " group
    if ! grep -q "^$group:" /etc/group; then
      read -p "Группа не существует. Создать? [Yes/No] " gpcreate
      case $gpcreate in
        Yes | Да | Y)
          sudo groupadd $gpcreate
          ;;
        No | Нет | N)
          read -p "Хотите указать другую группу? [Yes/No] " gpchange
          case $gpchange in
            Yes | Да | Y)
              ;;
            No| Нет | N)
              break
              ;;
          esac
          ;;
      esac
    fi
    done
    ;;
  No | Нет | N)
    ;;
esac