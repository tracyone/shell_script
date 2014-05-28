#!/bin/bash
# author:tracyone,tracyone@live.cn
# date:2014-05-28/08:21:39

shopt -s expand_aliases
read -p "请输入您的密码:" mypasswd
alias sudo="echo ${mypasswd} | sudo -S"

while [[ 1 ]]; do
	clear
	echo -e "-----------------------------------------"
	echo  "0,tftp自动启动开关"
	echo  "1,nfs自动启动开关"
	echo  "2,goagent自动启动开关"
	echo  "c,清理各种历史记录"
	echo  "s,查询启动状态"
	echo  "q,退出脚本"
	echo -e "-----------------------------------------"
	read -n1 -p  "请输入上面每一行前面的字母: " user_input
	echo -e "\n"
	until [[ "${user_input}" == [0-2qsc] ]]; do
		read -n1 -p  "对不起只有0到2和qsc允许被输入: " user_input
		echo -e "\n"
	done
	case ${user_input} in
		0 )
			if [[ -f "/etc/rc2.d/S20openbsd-inetd" ]]; then
				echo "禁止tftp自动启动..."
				sudo mv /etc/rc2.d/S20openbsd-inetd /etc/rc2.d/K20openbsd-inetd 
			else
				echo "开启tftp自动启动..."
				sudo mv /etc/rc2.d/K20openbsd-inetd /etc/rc2.d/S20openbsd-inetd 
			fi
			sleep 4
			continue
			;;
		1 )
			if [[ -f "/etc/rc2.d/S20nfs-kernel-server" ]]; then
				echo "禁止nfs自动启动..."
				sudo mv /etc/rc2.d/S20nfs-kernel-server /etc/rc2.d/K20nfs-kernel-server
			else
				echo "开启nfs自动启动..."
				sudo mv /etc/rc2.d/K20nfs-kernel-server /etc/rc2.d/S20nfs-kernel-server
			fi
			sleep 4
			continue
			;;
		2 )
			cat /etc/init.d/rc.local | grep proxy.py
			if [[ $? -ne 0 ]]; then
				echo "开启goagent自动启动..."
				cp /etc/init.d/rc.local ./tmp
				echo "python2.7 /opt/goagent/local/proxy.py" | tee -a tmp
				sudo mv tmp /etc/init.d/rc.local
			else
				echo "禁止goagent自动启动..."
				sudo sed -i '/proxy.py/d' /etc/init.d/rc.local
			fi
			sleep 4
			continue
			;;
		s )
			cat /etc/init.d/rc.local | grep proxy.py > /dev/null
			if [[ $? -ne 0 ]]; then
				echo "goagent: no"
			else
				echo "goagent: yes"
			fi
			if [[ -f "/etc/rc2.d/S20openbsd-inetd" ]]; then
				echo "tftp: yes"
			else
				echo "tftp: no"
			fi
			if [[ -f "/etc/rc2.d/S20nfs-kernel-server" ]]; then
				echo "nfs: yes"
			else
				echo "nfs: no"
			fi
			sleep 6
			continue
			;;
		c )
			echo "删除vim历史记录..."
			cd ~/.vim
			rm -rf ./sessions
			rm -rf ./.neocomplete
			rm -rf ./.unite
			rm -rf ./.vim-fuf-data
			rm -rf ./.vimshell
			rm -rf ./.love
			rm -rf ./vimbackup
			rm -rf ./.yank_history_v2.txt
			rm -rf ./.first_statup
			rm -rf ~/.viminfo
			echo "删除apt,软件中心cache..."
			sudo apt-get autoclean
			sudo apt-get clean
			echo "其它..."
			rm -rf ~/.zsh_history
			cd -
			sleep 5
			continue
			;;
		q )
			echo "tracyone:欢迎下次使用,bye"
			break
			;;
	esac
done
