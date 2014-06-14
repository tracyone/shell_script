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

mkdir ./temp
echo "添加仓库------------------------------------"
sleep 3
echo "添加 git 仓库..."
sudo add-apt-repository -y ppa:git-core/ppa
echo "添加 mercurial 仓库..."
sudo add-apt-repository -y ppa:mercurial-ppa/releases
echo "添加 tortoisehg 仓库..."
sudo add-apt-repository -y ppa:tortoisehg-ppa/releases
echo "添加 pidgin 仓库..."
sudo add-apt-repository -y ppa:lainme/pidgin-lwqq 
echo "添加 ubuntu-tweak 仓库..."
sudo add-apt-repository -y ppa:tualatrix/ppa
echo "添加 skype 仓库..."
sudo add-apt-repository -y "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
echo "添加darktable 仓库..."
sudo add-apt-repository -y ppa:pmjdebruijn/darktable-release
sudo add-apt-repository -y ppa:pmjdebruijn/darktable-release-plus
echo "添加google drive 仓库..."
sudo add-apt-repository -y sudo add-apt-repository ppa:thefanclub/grive-tools
echo "Support i386 architecture"
sudo dpkg --add-architecture i386

echo "更新源...."
sudo apt-get update

echo "更新系统..."
sudo apt-get dist-upgrade -y

echo "安装和配置 git svn等版本管理工具...."
sleep 3
sudo apt-get install git gitk git-gui git-svn -y
git config --global user.name "tracyone"
git config --global user.email "tracyone@live.cn"
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=86400'
git config --global core.editor vim

echo "安装goagent..."
sleep 3
git clone https://github.com/goagent/goagent ./goagent
sudo rm -rf /opt/goagent 
sudo cp -a ./goagent /opt
sudo chown -R $(whoami) /opt/goagent
sudo chgrp -R $(whoami) /opt/goagent
sudo apt-get -y install python-vte
echo "配置goagent..."
sleep 3
python /opt/goagent/server/uploader.zip
sudo sed -ie 's/^appid.*/appid = raoxiaowen1989|raoxiaowen1990|raoxiaowen1991|raoxiaowen1992/' /opt/goagent/local/proxy.ini
echo "开机启动goagent..."
sleep 3
echo -e "python /opt/goagent/local/proxy.py" | sudo tee -a /etc/init.d/rc.local

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
sudo apt-get  install mercurial python-nautilus tortoisehg -y
sudo apt-get  install unrar p7zip-full zhcon xbacklight shutter wallch wmctrl -y
sudo apt-get install vlc -y
sudo apt-get lm-sensors -y
sudo apt-get hddtemp -y
sudo apt-get skype -y
sudo apt-get grive-tools -y
sudo apt-get -y install dconf-editor
sudo apt-get -y install gparted ubuntu-tweak

echo "嵌入式开发.."
sudo apt-get install putty -y
sudo apt-get install openbsd-inetd tftp-hpa tftpd-hpa -y
sudo apt-get install nfs-kernel-server -y
sudo apt-get install bison flex mtd-utils -y
echo "设置tftp..."
mkdir ~/tftpboot
chmod 777 ~/tftpboot
echo -e "RUN_DAEMON=\"yes\"" | sudo tee  /etc/default/tftpd-hpa
echo -e "OPTIONS=\"-l -s -c /home/$(whoami)/tftpboot\"" | sudo tee -a /etc/default/tftpd-hpa
echo -e "TFTP_USERNAME=\"root\"" | sudo tee -a /etc/default/tftpd-hpa
echo -e "TFTP_DIRECTORY=\"/home/$(whoami)/tftpboot\"" | sudo tee -a /etc/default/tftpd-hpa
echo -e "TFTP_ADDRESS=\"0.0.0.0:69\"" | sudo tee -a /etc/default/tftpd-hpa
echo -e "TFTP_OPTIONS=\"--secure\"" | sudo tee -a /etc/default/tftpd-hpa
sudo service tftpd-hpa restart
echo "设置nfs..."
mkdir ~/nfsroot
chmod 777 ~/nfsroot
echo -e "/home/$(whoami)/nfsroot *(rw,no_root_squash,no_all_squash,sync)" | sudo tee -a /etc/exports
sudo exportfs -av
sudo service nfs-kernel-server restart 

if [[ ! -d "linux-config" ]];then
   git clone https://github.com/tracyone/linux-config 
fi
sudo ln -s /usr/bin/make /usr/bin/gmake
sudo cp ./linux-config/*.desktop /usr/share/applications/

echo "安装oh my zsh..."
rm -rf ~/.oh-my-zsh
sudo apt-get install zsh -y
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
echo "修改当前用户默认shell为zsh..."
echo "待补充暂时不知道如何实现..."
echo "恢复.zshrc"
cp ./linux-config/.zshrc ~


echo "Install steam..."
sudo apt-get install steam steam-launcher -y

echo "安装adobe flash player..."
if [[ ! -f "install_flash_player_11_linux.x86_64.tar.gz" ]];then
   wget http://fpdownload.macromedia.com/get/flashplayer/pdc/11.2.202.341/install_flash_player_11_linux.x86_64.tar.gz
fi
tar -xvf install_flash_player_11_linux.x86_64.tar.gz -C ./temp
sudo cp -a temp/libflashplayer.so /usr/lib/mozilla/plugins
sudo cp -a temp/usr/* /usr
rm -rf ./temp/

echo "下载专区------------------------------------"
sudo apt-get install nautilus-dropbox -y

sudo mkdir deb_file
cd deb_file
echo "下载搜狗输入法..."
echo "下载dropbox ..."
if [[ ${is_64} == "0" ]]; then
	wget "http://pinyin.sogou.com/linux/download.php?f=linux&bit=32"
	wget  "https://linux.dropbox.com/packages/ubuntu/dropbox_1.6.2_i386.deb" 
else
	wget "http://pinyin.sogou.com/linux/download.php?f=linux&bit=64"
	wget  "https://linux.dropbox.com/packages/ubuntu/dropbox_1.6.2_amd64.deb" 
fi
sudo dpkg -i *.deb 
cd ..
rm -rf deb_file


echo "安装字体...需要很长时间请耐心等待..."
if [[ ! -d "program_font" ]];then
   git clone https://github.com/tracyone/program_font
fi
sudo chmod -R a+x program_font/*
sudo mkdir -p /usr/share/fonts/MyFonts
mkdir ~/.fonts/
cp ./program_font/* ~/.fonts/
sudo cp ./program_font/* /usr/share/fonts/MyFonts
sudo fc-cache -f -v

echo "安装 gvim..."
sudo apt-get -y install vim-gtk cscope exuberant-ctags
mkdir ~/.vim
git clone https://github.com/tracyone/vim.git ~/.vim/vim
cp ~/.vim/vim/.vimrc ~
echo -e "Defaults\talways_set_home" | sudo tee -a /etc/sudoers
sudo ln -s /home/tracyone/.vim /root/.vim
sudo ln -s /home/tracyone/.vimrc /root/.vimrc
echo "安装gvim插件...可能需要比较长时间..."
gvim -c :BundleInstall &

echo "避免ubuntu字体发虚..."
sudo apt-get remove fonts-arphic-ukai ttf-wqy-zenhei fonts-arphic-uming -y

echo "清除工作...."
sudo apt-get autoremove -y
sudo apt-get autoclean
sudo apt-get clean
echo "温馨提示：电脑将在30分钟后关机.."
sudo shutdown -h 30

