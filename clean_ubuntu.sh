#!/bin/bash

sudo apt-get autoclean
sudo apt-get clean
sudo apt-get autoremove


echo -e "Clean usless kernel ...\n"

current_kernel=$(uname -a | grep -E -o '[0-9]+\.[0-9]+\.[0-9]+-[0-9]+')

remove_list=$(sudo dpkg --get-selections |grep -E -o '^linux-(headers|image)[^ ]*-[0-9]+\.[0-9]+\.[0-9]+-[0-9]+[^ ]*\s' | grep -v ${current_kernel})

echo ${remove_list}
for i in ${remove_list}; do
	echo -e "remove $i ... \n"
	sudo apt-get remove $i -y
	sleep 3
done


