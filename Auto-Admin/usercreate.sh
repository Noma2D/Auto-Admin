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
read -s -p "Введите пароль пользователя $username " password

read -p "Пользователь администратор? [Yes/No] " system
case $system in
  Yes | Да | Y | Д)
    sudo useradd -r -m -p $password $username
    ;;
  No | Нет | N | Н)
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
  Yes | Да | Y | Д)
    while $true; do
    read -p "Введите имя группы " group
    if ! grep -q "^$group:" /etc/group; then
      read -p "Группа не существует. Создать? [Yes/No] " gpcreate
      case $gpcreate in
        Yes | Да | Y | Д)
          sudo groupadd $gpcreate
          ;;
        No | Нет | N | Н)
          read -p "Хотите указать другую группу? [Yes/No] " gpchange
          case $gpchange in
            Yes | Да | Y | Д)
              ;;
            No| Нет | N | Н)
              break
              ;;
          esac
          ;;
      esac
    fi
    done
    ;;
  No | Нет | N | Н)
    ;;
esac