# shell_script

我自己做的一些脚本，大家有兴趣也可以拿去用。

## backup_ub

这是一个当初备份这个ubuntu 10.04虚拟机的脚本使用的是tar备份，而还要处理grub，后来觉得很傻其实可以用dd的。

## network_quick_switch

这个小脚本的功能快速切换切换网络配置，包括mac地址、IP地址和DNS。这个脚本有以下特性:

1. 用户可以迅速的切换到任意配置好的ip配置上;
2. 用户可以迅速恢复到最初的ip配置上;
3. 用户可以在配置界面上添加/删除一个新的配置，也可以直接修改配置文件;
4. 此脚本支持windows xp、windows 7、ubuntu及其衍生版和debian及其衍生版;
5. 配置文件的格式:新一行以#开头的为注释，所有注释会被忽略,所有空行会被忽略
6. 配置名:IP地址:MAC地址:DNS

**注意事项** 

1. 要想本脚本在linux和windows下都顺利执行的话，必须保证首先本文本的文件编码必须是cp936
2. 其次本脚本的文字编码必须是unix
3. 对于windows来说:必须安装MinGw或者CgyWin,另外windows xp的netsh有bug无法重启网卡所以,windows xp还需要安装devcon(命令行程序),windows 7以及以上的必须以管理员权限运行mingw，或者把UAC调到最低
4. 对于linux来说:必须安装resolvconf和ifupdown,当然百分之90概率你的系统自带了这两个命令,没有的话就`sudo apt-get install 包名`

**截图** 



## software_install.sh

这是我的电脑独立安装的最新版本的ubuntu的软件装机脚本。

[直接查看脚本里面做了些什么](software_install.sh)

## si4lucid.sh

这是上面对应功能脚本的ubuntu 10.04的版本。

## xlight

这个脚本是基于命令`xbacklight`编写的脚本，在调整亮度的时候将亮度写入配置文件，并且可以读取这个记录。

语法举例:

```bash
xlight -dec 10 #减少百分之10的亮度
xlight -inc 34 #增加百分之34的亮度
xlight  #读取配置文件恢复指定的亮度
```

## gif-record gif录制小脚本

一个基于byzanz工具的基于窗口的gif录制小脚本。

特性:

1. 倒数5秒后开始
2. 声音提示开始，声音提示结束
3. 窗口截图，在运行脚本之后，点击鼠标选择要录制的窗口
4. 本人比较懒所以录制的文件是直接保存到家目录的图片文件夹(图片/Pictures)下的gif-record

语法举例:

```bash
gif-record #直接录制默认录制时间是10秒
gif-record 20 #录制20秒
```

