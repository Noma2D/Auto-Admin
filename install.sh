#!/bin/bash
script_folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
sudo dpkg -i $script_folder/Auto-Admin.deb

if command -v Auto-Admin >/dev/null; then
    echo "Установка завершена"
else
    echo "Установка завершилась с ошибкой"
fi