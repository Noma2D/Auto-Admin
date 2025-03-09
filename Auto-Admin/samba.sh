samba_install(){
    sudo apt install samba -y
    sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.back
    read -p "Введите имя сервера: " sername
    read -p "Введите рабочую группу (по умолчанию WORKGROUP): " workgroup
    workgroup=${workgroup:-WORKGROUP}
    read -p "Введите название общей папки: " sharename
    read -p "Введите путь к общей папке [/srv/samba/share]: " sharepath
    sharepath=${sharepath:-/srv/samba/share}
    mkdir -p "$sharepath"
    chown -R root:smbgroup "$sharepath"
    chmod -R 2770 "$sharepath"

    read -p "Сделать ли папку только для чтения - yes/no ? [no] " $rdnly
    rdnly=${rdnly:-no}
    read -p "Разрешить ли доступ гостям - yes/no? [yes] " gstok
    gstok=${gstok:-yes}

    read -p "Подключать пользователей из Windows? (y/n): " win_support
    if [[ "$win_support" =~ ^[YyДд]$ ]]; then   
        read -p "Введите название группы для Windows-пользователей [winusers]: " wingroup
        wingroup=${wingroup:-winusers}
        groupadd -f "$wingroup"
        win_params="
        ntlm auth = yes
        client min protocol = NT1
        client max protocol = SMB3"
    else    
        win_params=""
    fi

    cat <<EOF > /etc/samba/smb.conf
[global]
    workgroup = $workgroup
    server string = $sername
    security = user
    map to guest = Bad User
    $win_params

[$sharename]
    path = $sharepath
    browseable = yes
    read only = $rdnly
    guest ok = $gstok
    valid users = @smbgroup @${wingroup:-none}
    create mask = 0660
    directory mask = 0770
EOF
    # Перезапуск Samba
    systemctl restart smbd nmbd
    echo "Конфигурация Samba успешно создана и перезапущена."
}

samba_add() {
    if [ ! -f "/etc/samba/smb.conf" ]; then
        echo "Ошибка: Файл конфигурации Samba не найден."
        return 1
    fi

    while true; do
        read -p "Введите имя новой общей папки: " sharename
        if grep -q "^\[$sharename\]" /etc/samba/smb.conf; then
            echo "Папка с таким именем уже существует в конфигурации. Попробуйте другое имя."
        else
            break
        fi
    done

    while true; do
        read -p "Введите путь к новой папке (например, /srv/samba/newshare): " sharepath
        if [ ! -d "$sharepath" ]; then
            read -p "Папка не существует. Создать её? (y/n): " create_folder
            if [[ "$create_folder" =~ ^[YyДд]$ ]]; then
                mkdir -p "$sharepath"
                echo "Папка $sharepath успешно создана."
            else
                echo "Укажите корректный путь."
                continue
            fi
        fi
        break
    done

    read -p "Разрешить гостевой доступ? (y/n): " guest_access
    guest_access=${guest_access,,}
    guest_setting=$([ "$guest_access" == "y" ] && echo "yes" || echo "no")

    read -p "Разрешить запись в папку? (y/n): " write_access
    write_access=${write_access,,}
    read_only_setting=$([ "$write_access" == "y" ] && echo "no" || echo "yes")

    cat <<EOF >> /etc/samba/smb.conf

[$sharename]
    path = $sharepath
    browseable = yes
    read only = $read_only_setting
    guest ok = $guest_setting
EOF

    chmod -R 2770 "$sharepath"
    chown -R root:smbgroup "$sharepath"

    systemctl restart smbd nmbd
    echo "Общая папка '$sharename' успешно добавлена в конфигурацию Samba."
}

samba_remove() {
     if [ ! -f "/etc/samba/smb.conf" ]; then
        echo "Ошибка: Файл конфигурации Samba не найден."
        return 1
    fi
    read -p "Введите имя общей папки для удаления: " sharename
    if grep -q "^\[$sharename\]" /etc/samba/smb.conf; then
        sed -i "/^\[$sharename\]/,/^$/d" /etc/samba/smb.conf
        systemctl restart smbd nmbd
        echo "Общая папка '$sharename' удалена из конфигурации Samba."
    else
        echo "Ошибка: Папка '$sharename' не найдена в конфигурации."
    fi
}

case $1 in
    install)
        samba_install
        ;;
    add)
        samba_add
        ;;
    remove)
        samba_remove
        ;;
    *)
        echo "Укажите install или add или remove"
        exit 1
        ;;
esac