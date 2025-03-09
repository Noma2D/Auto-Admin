#! /bin/bash

if ! command -v nginx &> /dev/null; then
    echo "Nginx не найден, установка."
    sudo apt install nginx -y
fi

read -p "Введите доменное имя (например, example.com): " domain
read -p "Введите путь к корневой директории (например, /var/www/html): " root_dir
mkdir -p "$root_dir"

read -p "Добавить поддержку обратного прокси? (y/n): " enable_proxy
if [[ "$enable_proxy" =~ ^[YyДд]$ ]]; then
    read -p "Введите адрес для проксирования (например, http://localhost:3000): " proxy_pass
    proxy_config="location / {
        proxy_pass $proxy_pass;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }"
else
    proxy_config="location / {
        index index.html index.htm index.php;
        try_files \$uri \$uri/ =404;
    }"
fi

read -p "Добавить поддержку PHP-FPM (LEMP-стек)? (y/n): " enable_php
if [[ "$enable_php" =~ ^[YyДд]$ ]]; then
    php_config="location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }"
else
    php_config=""
fi

read -p "Добавить поддержку HTTPS и сертификатов? (y/n): " enable_ssl
if [[ "$enable_ssl" =~ ^[YyДд]$ ]]; then
    read -p "Введите путь к SSL-сертификату (например, /etc/ssl/certs/example.crt): " ssl_cert
    read -p "Введите путь к SSL-ключу (например, /etc/ssl/private/example.key): " ssl_key

    if [ ! -f "$ssl_cert" ] || [ ! -f "$ssl_key" ]; then
        echo "Ошибка: Указанные файлы сертификата или ключа не найдены."
        exit 1
    fi

    ssl_config="
server {
    listen 443 ssl;
    server_name $domain;

    ssl_certificate $ssl_cert;
    ssl_certificate_key $ssl_key;

    root $root_dir;
    index index.html index.htm index.php;

    $proxy_config

    $php_config
}

server {
    listen 80;
    server_name $domain;

    return 301 https://\$host\$request_uri;
}
"
else
    ssl_config="server {
    listen 80;
    server_name $domain;

    root $root_dir;
    index index.html index.htm index.php;

    $proxy_config

    $php_config
}"
fi

# Создание конфигурационного файла
config_file="/etc/nginx/sites-available/$domain"
echo "$ssl_config" > "$config_file"

# Активация конфигурации
ln -s "$config_file" "/etc/nginx/sites-enabled/" 2>/dev/null
nginx -t && systemctl restart nginx

echo "Конфигурация Nginx успешно создана и активирована."
echo "Домен: $domain"
echo "Корневая директория: $root_dir"