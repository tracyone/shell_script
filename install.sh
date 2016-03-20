#!/bin/bash
# install my shell script and dependence

source ./script_libs/common.sh

sudo mkdir -p /usr/local/bin/script_libs
sudo ln -sf $(pwd)/git_utils.sh /usr/local/bin/git_utils
libs=$(ls script_libs/)
for i in $libs; do
	sudo ln -sf $(pwd)/script_libs/$i /usr/local/bin/script_libs/$i
done

if [[ $(GetOsType) == "LINUX" ]]; then
	sudo apt-get install sox byzanz -y
	git clone https://github.com/lolilolicon/FFcast2
	cd FFcast2
	make
	sudo cp xrectsel /usr/bin
	cd ..
	rm -rf FFCAST2
	sudo ln -sf $(pwd)/gif_record /usr/local/bin/gif_record
	sudo ln -sf $(pwd)/chwall.sh /usr/local/bin/chwall
fi
