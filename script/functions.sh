#!/bin/bash


case "$1" in
update)

for up in update upgrade
do

apt-get $up -y 

done

;;

repo)

add-apt-repository ppa:ondrej/php5-5.6 -y

apt-get update

;;

install)

echo $2 > /etc/hostname

debconf-set-selections <<< "postfix postfix/mailname string $2"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"

for cmd in apache2 php5 postfix

do 

apt-get install $cmd -y
done

;;

vstatus)

for stats in php apache2 postfix
do

dpkg -l | grep $stats | egrep i | cut -d " " -f 3

done

;;

copy)


dir=$(grep -rin 'DocumentRoot' /etc/apache2/sites-available/ | head -n1 | cut -d " " -f 2)
diretorio=`echo $dir'/'`

echo $diretorio

;;

pwds)

dir=$(grep -rin 'DocumentRoot' /etc/apache2/sites-available/ | head -n1 | cut -d " " -f 2)
diretorio=`echo $dir'/'`

ls $diretorio | grep php 




esac
 
