#!bin/bash

# Написать сценарий завершения процесса по его имени, включая все дочерние процессы.
# Завершение процессов должно быть корректным (мягким), по завершению работы в консоль должно быть выведено сообщение о корректном процесса,
# включая его потомков с указанием списка завершенных процессов. 
# В случае отсутствия процесса имя которого указано в качестве аргумента,
# завершить его выполнение с выводом в консоль кода завершения и сообщения об ошибке.

read -p "Enter processname : " parent_name
pgrep -o "$parent_name"
if [ $? -eq 0 ]; then
	echo "Parent process exists with pid = $(pgrep -o $parent_name)"
	ps aux | grep "$(pgrep -o $parent_name)" | head -n 1
	echo "Kill $parent_name"
	kill 15 "$(pgrep -o $parent_name)"
	echo "Killed $parent_name\n"

	pids=$(pgrep -P $(pgrep -o $parent_name))
	if [ "$pids" ]; then
		for pid in $pids
		do
			echo "Child process exists with pid = $pid"
			ps aux | grep "$pid" | head -n 1
			echo 'Killing'
			kill -15 $pid
			if [ $? -eq 0 ]; then
				echo "Killed successfully $pid\n"
			else
				echo "Killed unsuccessfully $pid\n"
			fi 
		done
	fi
else
	echo 'No process'
	exit 1
fi