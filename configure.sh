#!/bin/bash


echo "INSTALANDO DEPENDENCIAS".

for i in zenity yad sshpass
do

apt-get install $i 2>/dev/null

done


echo "Dependencias Instaladas "


echo "Realizando Ajustes....."



mkdir /opt/packegesins
cp -r . /opt/packegesins


echo "você já pode usar o packegesins."


