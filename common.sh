#!/bin/bash
# several common function of bash script

# 参数1是执行的命令字符串
function execute_check
{
	$1
	if [[  $? -eq 0 ]]; then
		echo -e "\nExecute \"$1\" Successfully"
	else
		echo -e "\nExecute \"$1\" failed"
	fi
}

# 参数1为提示字符串，参数2为y时执行的命令
function GetYn
{
	local tmp
	local regex="[yY]"
	read -n1 -p "$1 [Y/n]" tmp
	echo -e "\n"
	if [[  $tmp =~ $regex ]]; then
		for (( i = 1; i <= $#; i++ )); do
			shift
			execute_check "$1"
		done
	else
		echo -e "\nNothing to do"
	fi
}

# 类似我们编译众多linux软件源代码时configure程序的作用
# 接受一个字符串参数，每个命令之间用空格隔开...
function configure()
{
	local package_lack=""
	for i in $1
	do
		which $i > /dev/null 2>&1
		if [[ $? -ne 0 ]]; then
			echo -e "Checking for $i ..... no"
			package_lack="$i ${package_lack}"
		else
			echo -e "Checking for $i ..... yes"
		fi
	done	
	if [[ ${package_lack} != "" ]]; then
		echo "Please install ${package_lack} manually!"
		exit 3
	fi
}

function clear_screen()
{
	# clear screen
	echo -e "\e[2J\e[1;1H"
}

#接受一个参数,就是字符串..
function get_str_len()
{
	echo ${#1}
}

# 接受一个参数,url字符或者http地址
function url_decode()
{
	for url in $1
	do
		printf $(echo -n $url | sed 's/\\/\\\\/g;s/\(%\)\([0-9a-fA-F][0-9a-fA-F]\)/\\x\2/g')"\n"
	done
}
