#!/bin/bash

#Написать сценарий для добавления нового пользователя в систему с созданием его домашнего каталога, настройки окружения пользователя. 
#Имя, пароль и подтверждения пароля пользователя вводятся с клавиатуры при запуске сценария. 
#При попытке создания пользователя, который уже существует, сценарий должен завершаться с выводом в консоль кода завершения и сообщения об ошибке.
# ./t2-1.sh then enter username and enter password
if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	read -s -p "Enter password : " password
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		useradd -m -p $pass $username
		[ $? -eq 0 ] && echo "User added" || echo "User not added"
	fi
else
	echo "Only root may add a user to the system"
	exit 2
fi