#!/bin/bash
# author:tracyone,tracyone@live.cn
# file:software_install.sh
# author:tracyone,tracyone@live.cn
# date:2014-02-22/23:53:04
# description:ubuntu装机脚本..
# lastchange:2014-04-01

# 判断是32位还是64位系统
MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
  is_64=1
else
  is_64=0
fi

shopt -s expand_aliases
read -p "请输入您的密码:" mypasswd
alias sudo="echo "${mypasswd}" | sudo -S"

if [[ -d ~/Work ]]; then
	mkdir -p ~/Work
fi
cd ~/Work

mkdir ./temp
echo "添加仓库------------------------------------"
sleep 3
echo "添加 git 仓库..."
sudo add-apt-repository -y ppa:git-core/ppa
echo "添加 pidgin 仓库..."
sudo add-apt-repository -y ppa:lainme/pidgin-lwqq 
echo "添加 skype 仓库..."
sudo add-apt-repository -y "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
echo "添加darktable 仓库..."
sudo add-apt-repository -y ppa:pmjdebruijn/darktable-release
sudo add-apt-repository -y ppa:pmjdebruijn/darktable-release-plus
echo "Support i386 architecture"
sudo dpkg --add-architecture i386

echo "更新源...."
sudo apt-get update

echo "更新系统..."
sudo apt-get dist-upgrade -y

echo "安装和配置 git svn等版本管理工具...."
sleep 3
sudo apt-get install git gitk git-gui git-svn -y

echo "安装compiz特效管理..."
sleep 3
sudo apt-get install compiz-plugins compiz-plugins-extra compizconfig-settings-manager -y

echo "安装 qt4..."
sleep 3
sudo apt-get install libqt4-dev libqt4-dbg libqt4-gui libqt4-sql qt4-dev-tools qt4-doc qt4-designer qt4-qtconfig qtcreator -y

echo "安装java和java运行环境..."
sleep 3
sudo apt-get install openjdk-7-jdk -y

echo "安装CodeBlock..."
sleep 3
sudo apt-get install codeblocks g++ wx-common libwxgtk3.0-0 build-essential  wxformbuilder codeblocks-dbg codeblocks-contrib wx3.0-headers  wx3.0-i18n -y

echo "安装gimp,Inkscape等图形软件..."
sleep 3
sudo apt-get install gimp Inkscape Dia darktable darktable-plugins-experimental darktable-plugins-legacy -y

echo "安装 fcitx 输入法..."
sleep 3
sudo apt-get -y install fcitx fcitx-config-gtk fcitx-sunpinyin fcitx-googlepinyin fcitx-module-cloudpinyin

echo "安装VirtualBox"
sleep 3
sudo apt-get install virtualbox virtualbox-guest-additions-iso vde2 -y

echo "安装 pidgin ... "
sleep 3
sudo apt-get install libpurple0 pidgin pidgin-lwqq -y 

echo "安装goldendict..."
sleep 3
sudo apt-get install goldendict goldendict-wordnet -y

echo "安装nautils相关..."
sleep 3
sudo apt-get  install nautilus-open-terminal nautilus-actions -y

echo "安装其它杂七杂八.."
sleep 3
sudo apt-get  install python-nautilus -y
sudo apt-get  install unrar p7zip-full zhcon xbacklight shutter wallch wmctrl -y
sudo apt-get install vlc -y
sudo apt-get lm-sensors -y
sudo apt-get hddtemp -y
sudo apt-get skype -y
sudo apt-get grive-tools -y
sudo apt-get -y install dconf-editor
sudo apt-get -y install gparted ubuntu-tweak
echo "exfat support ..."
sudo apt-get -y exfat-utils

echo "嵌入式开发.."
sudo apt-get install putty -y
sudo apt-get install openbsd-inetd tftp-hpa tftpd-hpa -y
sudo apt-get install nfs-kernel-server -y
sudo apt-get install bison flex mtd-utils -y
echo "设置tftp..."
mkdir ~/Work/tftpboot
chmod 777 ~/Work/tftpboot
echo -e "RUN_DAEMON=\"yes\"" > tftpd-hpa
echo -e "OPTIONS=\"-l -s -c /home/$(whoami)/Work/tftpboot\"" >> tftpd-hpa
echo -e "TFTP_USERNAME=\"root\"" >> tftpd-hpa
echo -e "TFTP_DIRECTORY=\"/home/$(whoami)/Work/tftpboot\"" >> tftpd-hpa
echo -e "TFTP_ADDRESS=\"0.0.0.0:69\"" >> tftpd-hpa
echo -e "TFTP_OPTIONS=\"--secure\"" >> tftpd-hpa
sudo mv tftpd-hpa /etc/default/tftpd-hpa
sudo service tftpd-hpa restart
echo "设置nfs..."
mkdir ~/Work/nfsroot
chmod 777 ~/Work/nfsroot
echo -e "/home/$(whoami)/Work/nfsroot *(rw,no_root_squash,no_all_squash,sync)" | sudo tee -a /etc/exports
sudo exportfs -av
sudo service nfs-kernel-server restart 

if [[ ! -d "linux-config" ]];then
   git clone https://github.com/tracyone/dotfile
fi
cd dotfile;./install.sh;cd -

echo "Install steam..."
sudo apt-get install steam steam-launcher -y

echo "Install chromium and Pepper Flash Player"
sudo apt-get install chromium-browser
sudo apt-get install pepperflashplugin-nonfree
sudo update-pepperflashplugin-nonfree --install

sudo apt-get install nautilus-dropbox -y

echo "Install Sogou input ..."
if [[ is_64 == 1 ]]; then
	wget -c "http://pinyin.sogou.com/linux/download.php?f=linux&bit=64" sogoupinyin.deb
else
	wget -c "http://pinyin.sogou.com/linux/download.php?f=linux&bit=32" sogoupinyin.deb
fi
sudo dpkg -i sogoupinyin.deb


echo "安装字体...需要很长时间请耐心等待..."
if [[ ! -d "program_font" ]];then
   git clone https://github.com/tracyone/program_font
fi
if [[  $? -eq 0 ]]; then
	sudo chmod -R a+x program_font/*
	sudo mkdir -p /usr/share/fonts/MyFonts
	mkdir ~/.fonts/
	cp ./program_font/* ~/.fonts/
	sudo cp ./program_font/* /usr/share/fonts/MyFonts
	sudo fc-cache -f -v
fi

if [[ -d "vim_conf" ]]; then
	git clone https://github/tracyone/vim vim_conf
fi
if [[ $? -eq 0 ]]; then
	cd vim_conf ;./build_vim.sh all && gvim -c :BundleInstall &
	cd -
fi


echo "避免ubuntu字体发虚..."
sudo apt-get remove fonts-arphic-ukai ttf-wqy-zenhei fonts-arphic-uming -y

echo "清除工作...."
sudo apt-get autoremove -y
sudo apt-get autoclean
sudo apt-get clean
echo "温馨提示：电脑将在30分钟后关机.."
sudo shutdown -h 30

