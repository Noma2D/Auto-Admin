# /bin/bash/
# install dependencies

#!/bin/bash

# Проверка операционной системы
if [ -f /etc/debian_version ]; then
	# Проверка установки Docker
	if ! command -v docker &>/dev/null; then
		# Установка Docker
		echo "Установка Docker..."
		sudo apt-get update
		sudo apt-get install -y docker.io
		sudo systemctl start docker
		sudo systemctl enable docker
		echo "Docker установлен успешно."
	else
		echo "Docker уже установлен."
	fi

	# Проверка установки Docker Compose
	if ! command -v docker-compose &>/dev/null; then
		# Установка Docker Compose
		echo "Установка Docker Compose..."
		sudo apt-get install -y docker-compose
		echo "Docker Compose установлен успешно."
	else
		echo "Docker Compose уже установлен."
	fi
elif [ -f /etc/redhat-release ]; then
	# Добавьте поддержку других дистрибутивов по необходимости
	echo "Поддержка других дистрибутивов не реализована."
else
	echo "Не удалось определить дистрибутив Linux."
fi

if ! command -v python3 &>/dev/null; then
	echo "Python не найден. Установка..."
	sudo apt-get update
	sudo apt-get install -y python3
else
	echo "Python уже установлен."
fi

# Проверка наличия pip
if ! command -v pip &>/dev/null; then
	echo "pip не найден. Установка..."
	sudo apt-get update
	sudo apt-get install -y python3-pip
else
	echo "pip уже установлен."
fi

# Проверка наличия PyYAML
if ! python3 -c "import yaml" &>/dev/null; then
	echo "PyYaml не найден. Установка..."
	sudo pip install PyYaml
else
	echo "PyYaml уже установлен."
fi

# install ansible
sudo apt install ansible

# main.py
python3 ./monitoring-system/main.py

sudo docker-compose up
