#!/bin/sh

sudo su -
yum -y update

yum -y install zip unzip

###########
##  git  ##
###########
yum -y install gcc gcc-c++
yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker git

cd /usr/local/src
git clone git://git.kernel.org/pub/scm/git/git.git
cd git
make prefix=/usr/local all
make prefix=/usr/local install
yum -y remove git
ln -s /usr/local/bin/git /bin/git

###########
## nginx ##
###########
cat << NGINX >> /etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/\$basearch/
gpgcheck=0
enabled=1
NGINX

yum -y install --enablerepo=nginx nginx-1.12.0

###########
##  PHP  ##
###########
yum -y install epel-release
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
yum -y install --enablerepo=remi-php71 php-7.1.14 php-mbstring php-pear php-fpm php-mcrypt php-mysql

###########
## MySQL ##
###########
yum -y remove mariadb-libs
rm -rf /var/lib/mysql/
yum -y localinstall http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
yum -y install mysql-community-server

##############
## Composer ##
##############
cd /usr/local/src
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

##############
## npm ##
##############
yum -y install nodejs npm

#############
## 各種設定 ##
#############
# php.ini設定
cp /etc/php.ini /etc/php.ini.org
sed -i -e 's/;date.timezone =/date.timezone = "Asia\/Tokyo"/g' /etc/php.ini

# /etc/php-fpm.d/www.conf設定
cp /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf.org
sed -i -e 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf
sed -i -e 's/group = apache/group = nginx/g' /etc/php-fpm.d/www.conf
sed -i -e 's/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm\/php-fpm.sock/g' /etc/php-fpm.d/www.conf
sed -i -e 's/;listen.owner = nobody/listen.owner = nginx/g' /etc/php-fpm.d/www.conf
sed -i -e 's/;listen.group = nobody/listen.group = nginx/g' /etc/php-fpm.d/www.conf
sed -i -e 's/;listen.mode = 0660/listen.mode = 0660/g' /etc/php-fpm.d/www.conf

# nginx設定
mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.org

cat << NGINX > /etc/nginx/conf.d/default.conf
server {
    listen       80;
    server_name  localhost;
    root   /usr/share/nginx/html/public;
    sendfile off;

    location / {
        index  index.php index.html index.htm;
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
    }

    location ~ \.php\$ {
        fastcgi_pass   unix:/var/run/php-fpm/php-fpm.sock;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;
        include        fastcgi_params;
    }
}
NGINX

# /etc/my.cnf
mv /etc/my.cnf /etc/my.cnf.org

cat << MYCONF >> /etc/my.cnf
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
symbolic-links=0
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
character-set-server=utf8
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
default-storage-engine=InnoDB

[mysql]
default-character-set=utf8
MYCONF

#############
## 各種起動 ##
#############
systemctl enable php-fpm.service
systemctl start php-fpm.service
systemctl enable nginx.service
systemctl start nginx.service
systemctl enable mysqld.service
systemctl start mysqld.service

#############################
## MySQLのrootパスワード変更 ##
#############################
# 初期パスワードの取得
log_file=/var/log/mysqld.log
export tmp_pass=$(grep 'password is generated' $log_file | awk -F'root@localhost: ' '{print $2}')

# 設定したいパスワード
new_pass=j\(G2i8Jb

mysqladmin --password=$tmp_pass password $new_pass

# ユーザー追加&データベース追加
project_db=twitter
project_user=twitter
project_user_pass=Ah3\!\%\&i\/
echo "CREATE DATABASE $project_db;" | mysql -u root --password=$new_pass
echo "CREATE USER '$project_user'@'localhost' IDENTIFIED BY '$project_user_pass';" | mysql -u root --password=$new_pass
echo "GRANT ALL PRIVILEGES ON $project_db.* TO '$project_user'@'localhost';" | mysql -u root --password=$new_pass
