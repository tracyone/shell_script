# file:software_install.sh
# author:tracyone,tracyone@live.cn
# date:2014-02-22/23:53:04
# description:ubuntu装机脚本..
# lastchange:2014-02-22/23:54:02

mkdir ./temp
echo "添加仓库------------------------------------"
echo "添加 git 仓库.."
sudo add-apt-repository -y ppa:git-core/ppa
echo "添加 mercurial 仓库..."
sudo add-apt-repository -y ppa:mercurial-ppa/releases
echo "添加 tortoisehg 仓库..."
sudo add-apt-repository -y ppa:tortoisehg-ppa/releases
echo "添加 fcitx 仓库..."
sudo add-apt-repository -y ppa:fcitx-team/nightly
echo "添加 pidgin 仓库..."
sudo add-apt-repository -y ppa:lainme/pidgin-lwqq 

echo "Update source...."
sudo apt-get update

echo "安装compiz特效管理..."
sudo apt-get install compiz-plugins compiz-plugins-extra compizconfig-settings-manager -y

echo "安装 qt4..."
sudo apt-get install libqt4-dev libqt4-dbg libqt4-gui libqt4-sql qt4-dev-tools qt4-doc qt4-designer qt4-qtconfig -y

echo "安装和配置 git...."
sudo apt-get -y install git
git config --global user.name "tracyone"
git config --global user.email "tracyone@live.cn"
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=86400'

echo "卸载ibus然后安装 fcitx 输入法..."
sudo apt-get -y remove ibus
sudo apt-get -y install fcitx fcitx-config-gtk fcitx-sunpinyin fcitx-googlepinyin fcitx-module-cloudpinyin im-switch

echo "安装 pidgin ... "
sudo apt-get install libpurple0 pidgin pidgin-lwqq -y 

echo "安装其它杂七杂八.."
sudo apt-get -y install mercurial python-nautilus tortoisehg
sudo apt-get -y install unrar p7zip-full zhcon xbacklight
sudo apt-get install vlc -y
sudo apt-get lm-sensors -y
sudo apt-get hddtemp -y
sudo apt-get -y install nautilus-open-terminal
sudo apt-get -y install dconf-editor

git clone https://github.com/tracyone/linux-config 

echo "安装oh my zsh..."
rm -rf ~/.oh-my-zsh
sudo apt-get install zsh -y
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
echo "修改当前用户默认shell为zsh..."
echo "待补充暂时不知道如何实现..."
echo "恢复.zshrc"
cp ./linux-config/.zshrc ~

echo "安装goagent..."
git clone https://github.com/goagent/goagent ./goagent
sudo rm -rf /opt/goagent 
sudo cp -a ./goagent /opt
sudo chown -R $(whoami) /opt/goagent
sudo chgrp -R $(whoami) /opt/goagent
sudo apt-get -y install python-vte
echo "配置goagent..."
python /opt/goagent/server/uploader.zip
sed -ie 's/^appid.*/appid = tracyone1989|tracyone1990/' /opt/goagent/local/proxy.ini

echo "安装adobe flash player..."
wget http://fpdownload.macromedia.com/get/flashplayer/pdc/11.2.202.341/install_flash_player_11_linux.x86_64.tar.gz
tar -xvf install_flash_player_11_linux.x86_64.tar.gz -C ./temp
sudo cp -a temp/libflashplayer.so /usr/lib/mozilla/plugins
sudo cp -a temp/usr/* /usr
rm -rf ./temp/*

echo "下载专区------------------------------------"
echo "下载 LoveWall paper"
mkdir ./deb安装包
wget http://s.qdcdn.com/lovebizhi/LoveWallpaper4Linux.deb ./deb安装包

echo "安装字体...需要很长时间请耐心等待..."
git clone https://github.com/tracyone/program_font
sudo chmod -R a+x program_font/*
sudo mkdir -p /usr/share/fonts/MyFonts
mkdir ~/.fonts/
cp ./program_font/* ~/.fonts/
sudo fc-cache -f -v

echo "安装 gvim"
sudo apt-get -y install vim-gtk
mkdir ~/.vim
git clone https://github.com/tracyone/vim.git ~/.vim/vim_rc
cp ~/.vim/vim_rc/.vimrc ~
echo "安装插件..."
gvim -c :BundleInstall &

echo "清除工作...."
sudo apt-get autoremove -y
sudo apt-get autoclean
sudo apt-get clean
echo "温馨提示：电脑将在30分钟后关机.."
sudo shutdown -h 30

#sudo gsettings set com.canonical.Unity.Panel systray-whitelist "['qtqq','ibus','fcitx', 'Update-notifier'] "
#echo 移除fcitx-frontend-gtk2..这货和gtk的gvim冲突
#sudo apt-get remove fcitx-frontend-gtk2 -y
