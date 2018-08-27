#!/bin/bash
echo "正在检测yum是否可用"
yum repolist | awk '/repolist/{ print $2} ' | sed 's/,//' 
N=$(yum repolist | awk '/repolist/{ print $2} ' | sed 's/,//')
if [ $N  -le 0 ];then
echo -e "\033[31myum 不可用\033[0m"
echo "正在安装yum"
rm -rf /etc/yum.repos.d/*
echo "学校用的yum源提供  ftp://192.168.4.254/rhel7
ftp://192.168.2.254/rhel7"
read -p "请输入yum源地址：" haha
yum-config-manager --add  $haha   > /dev/null
echo "gpgcheck=0" >> /etc/yum.repos.d/*.repo
else
echo  -e "\033[32myum可以使用\033[0m"
fi
################################################################################
cd
tar -xf lnmp_soft.tar.gz
cd lnmp_soft
tar -xf nginx-1.12.2.tar.gz
###############################################################################
while :
do
read -p "是否需要安装,请输入：
1 MariaDB
2 PHP
3 Nginx
4 Memcached 
5一起安装
6 退出:" hehe
if [ $hehe -eq 1 ];then
yum -y install  mariadb mariadb-server mariadb-devel
systemctl start mariadb
systemctl enable mariadb    > /dev/null
echo "正在检测是否可用："
ss -utnlp | grep :3306 > /dev/null &&  echo -e "\033[32mMairaDB安装完成\033[0m"|| echo -e "\033[31mMairaDB安装失败\033[0m"
################################################################################
elif [ $hehe -eq 2 ];then
cd
cd lnmp_soft
yum -y install php php-mysql php-fpm-5.4.16-42.el7.x86_64.rpm php-pecl-memcache
systemctl start php-fpm
systemctl enable php-fpm     > /dev/null
echo "正在检测是否可用："
ss -utnlp | grep :9000 > /dev/null &&  echo -e "\033[32mPHP安装完成\033[0m"|| echo -e "\033[31mPHP安装失败\033[0m"
################################################################################
elif [ $hehe -eq 3 ];then
yum -y install gcc openssl-devel pcre-devel httpd-tools
useradd -s /sbin/nologin nginx
cd
cd lnmp_soft
cd nginx-1.12.2
./configure  --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_ssl_module --with-stream --with-http_stub_status_module
make && make install
ln -s /usr/local/nginx/sbin/nginx /sbin/
cd
nginx          > /dev/null
echo "正在检测是否可用："
ss -utnlp | grep :80  > /dev/null  &&  echo -e "\033[32mNginx安装完成，快捷键Nginx生成\033[0m"|| echo -e "\033[31mNginx安装失败\033[0m"
################################################################################
elif [ $hehe -eq 4 ];then
yum -y install memcached
systemctl start memcached
systemctl enable memcached  > /dev/null
echo "正在检测是否可用："
ss -utnlp | grep :11211 > /dev/null &&  echo -e "\033[32mMemcached安装完成\033[0m"|| echo -e "\033[31mMemcached安装失败\033[0m"
################################################################################
elif [ $hehe -eq 5 ];then
useradd -s /sbin/nologin nginx
cd
cd lnmp_soft
yum -y install gcc openssl-devel pcre-devel mariadb mariadb-server mariadb-devel php php-mysql php-fpm-5.4.16-42.el7.x86_64.rpm php-pecl-memcache memcached httpd-tools
systemctl start mariadb
systemctl enable mariadb   > /dev/null
systemctl start php-fpm
systemctl enable php-fpm    > /dev/null
systemctl start memcached
systemctl enable memcached  > /dev/null
cd nginx-1.12.2
./configure  --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_ssl_module --with-stream --with-http_stub_status_module
make && make install
ln -s /usr/local/nginx/sbin/nginx /sbin/ && cd
nginx    > /dev/null
echo "正在检测是否可用："
ss -utnlp | grep :3306 > /dev/null &&  echo -e "\033[32mMairaDB安装完成\033[0m"|| echo -e "\033[31mMairaDB安装失败\033[0m"
ss -utnlp | grep :9000 > /dev/null &&  echo -e "\033[32mPHP安装完成\033[0m"|| echo -e "\033[31mPHP安装失败\033[0m"
ss -utnlp | grep :80  > /dev/null  &&  echo -e "\033[32mNginx安装完成，快捷键Nginx生成\033[0m"|| echo -e "\033[31mNginx安装失败\033[0m"
ss -utnlp | grep :11211 > /dev/null &&  echo -e "\033[32mMemcached安装完成\033[0m"|| echo -e "\033[31mMemcached安装失败\033[0m"
echo  -e "\033[32m脚本完成\033[0m" && exit
################################################################################
else
echo "安装如下："
ss -utnlp | grep :3306 > /dev/null
if [ $? -eq 0 ];then
echo -e "\033[32mMairaDB安装完成\033[0m" 
fi
ss -utnlp | grep :9000  > /dev/null
if [ $? -eq 0 ];then
echo -e "\033[32mPHP安装完成\033[0m"
fi
ss -utnlp | grep :80    > /dev/null
if  [ $? -eq 0 ];then
echo -e "\033[32mNginx安装完成，快捷键Nginx生成\033[0m" 
fi
ss -utnlp | grep :11211   > /dev/null
if  [ $? -eq 0 ];then
echo -e "\033[32mMemcached安装完成\033[0m"
fi
echo  -e "\033[32m脚本完成\033[0m" && exit
fi
done
