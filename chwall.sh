#!/bin/bash
# randomly chang background wallpaper in specified directory
# optional argument:The path of wallpaper
PID=$(pgrep gnome-session)
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2-)

DIR_WALLPAPER=/home/tracyone/Pictures/Wallpapers

if [[ $1 != "" ]]; then
	DIR_WALLPAPER=$1
fi

if [[ ! -d ${DIR_WALLPAPER} ]]; then
	echo -e "Directory ${DIR_WALLPAPER} is not exist!"
	exit 3
fi

cd ${DIR_WALLPAPER}

PIC_NAME=$(find . -regextype posix-egrep -regex '.*\.(jpg|png)' -type f | shuf -n1)
echo -e "we are going to change background to ${DIR_WALLPAPER}/${PIC_NAME#*./}"
PIC_NAME=${DIR_WALLPAPER}/${PIC_NAME#*./}

gsettings set org.gnome.desktop.background picture-options "zoom"

gsettings set org.gnome.desktop.background picture-uri file://${PIC_NAME} || echo "Failed to change background Wallpapers" 
#dconf write "/org/gnome/desktop/background/picture-uri" "file://${PIC_NAME}" ||  || echo "Failed to change background Wallpapers" 
