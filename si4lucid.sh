sudo apt-get purge '^openoffice.org-.*' -y
sudo apt-get purge ubuntuone-client -y
echo "添加 mercurial 仓库..."
sudo add-apt-repository  ppa:mercurial-ppa/releases
echo "添加 tortoisehg 仓库..."
sudo add-apt-repository  ppa:tortoisehg-ppa/releases
echo "添加openjdk 仓库 ..."
sudo add-apt-repository  ppa:openjdk/ppa

echo "更新源...."
sudo apt-get update

echo "安装和配置 git svn等版本管理工具...."
sleep 3
sudo apt-get install git gitk git-gui git-svn -y
git config --global user.name "tracyone"
git config --global user.email "tracyone@live.cn"
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=86400'
echo "安装java和java运行环境..."
sleep 3
sudo apt-get install openjdk-7-jdk -y


echo "安装CodeBlock..."
sleep 3
sudo apt-get install codeblocks g++ wx-common libwxgtk2.8-0 build-essential  wxformbuilder codeblocks-dbg codeblocks-contrib wx2.8-headers  wx2.8-i18n -y

echo "安装 pidgin ... "
sleep 3
sudo apt-get install libpurple0 pidgin

echo "安装nautils相关..."
sleep 3
sudo apt-get  install nautilus-open-terminal nautilus-actions -y

echo "安装其它杂七杂八.."
sleep 3
sudo apt-get  install mercurial python-nautilus tortoisehg -y
sudo apt-get  install unrar p7zip-full zhcon xbacklight shutter wallch wmctrl -y
sudo apt-get install vlc -y

if [[ ! -d "linux-config" ]];then
   git clone https://github.com/tracyone/linux-config 
fi
sudo ln -s /usr/bin/make /usr/bin/gmake
sudo cp ./linux-config/*.desktop /usr/share/applications/

echo "安装oh my zsh..."
rm -rf ~/.oh-my-zsh
sudo apt-get install zsh -y
wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
echo "修改当前用户默认shell为zsh..."
echo "待补充暂时不知道如何实现..."
echo "恢复.zshrc"
cp ./linux-config/.zshrc ~

echo "安装字体...需要很长时间请耐心等待..."
if [[ ! -d "program_font" ]];then
   git clone https://github.com/tracyone/program_font
fi
sudo chmod -R a+x program_font/*
sudo mkdir -p /usr/share/fonts/MyFonts
mkdir ~/.fonts/
cp ./program_font/* ~/.fonts/
sudo fc-cache -f -v

echo "编译安装最新版本的gvim..."
echo "安装编译gvim所需的依赖.."
sudo apt-get build-dep vim -y
sudo apt-get install lua50 liblua50-dev liblualib50-dev
sudo ln -s /usr/include/lua50/ /usr/include/lua

if [[ ! -d "vim-src" ]];then
    hg clone https://vim.googlecode.com/hg/ vim-src
    rm -rf ./vim-src/src/auto/config.cache
    cd vim-src/src
    sudo make uninstall
    make clean
    cd -
    rm -rf ./vim-src/src/auto/config.cache
    cd vim-src/src
    ./configure --with-x \
    --with-features=huge \
    --enable-luainterp=yes \
    --enable-perlinterp=yes \
    --enable-pythoninterp=yes \
    --enable-tclinterp \
    --enable-rubyinterp=yes \
    --enable-gui=auto \
    --enable-cscope \
    --enable-multibyte \
    --enable-fontset \
    --disable-smack \
    --with-compiledby=tracyone@live.cn
    make
    sudo make install
    cd -
else
    cd vim-src
    hg pull
    hg update
fi

echo "清除工作...."
sudo apt-get autoremove -y
sudo apt-get autoclean
sudo apt-get clean
echo "温馨提示：电脑将在30分钟后关机.."
sudo shutdown -h 30


