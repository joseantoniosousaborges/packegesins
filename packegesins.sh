#!/bin/bash

VAR=$( \
		yad --form \
		--title="PACKAGES INSTALL" \
		--borders=50 --text="<b>Sistema de instalação de pacotes remoto</b>"\
		--width=550 \
		--height=150 \
		--image="images/logo.png" \
		--separator="\\n" \
		--field="<b>Arquivo de Dados:</b>\n[.csv,.txt]":FL "$HOME" \
		--separator="\\n" \
		--field="<b>Selecione:</b>":CB 1-Verificar_conexão_com_servidores!2-Atualizar_repositorio_SO!3-Atualizar_Depensencias[PHP]!4-Instalar[PHP,APACHE,POSTFIX]!5-Verificar_pacotes_instalados!6-Alteracoes_especificas[PHP,APACHE,POSTFIX]!7-Importação_de_Arquivos[WEB] \
		--button=gtk-execute:0  --button=gtk-quit:8  

     ) 2>/dev/null


acao="$?"
test "$acao" -eq "8" || test "$acao" -eq "252"
if [ "$?" -eq "0" ]; then

exit

fi


op=`echo $VAR | cut -d "|" -f1 | cut -d " " -f2 | cut -d "-" -f1 `
file=`echo $VAR | cut -d "|" -f1 | cut -d " " -f1`
case $op in

"1")

for linha in `cat $file 2>/dev/null`; do

login=`echo $linha | cut -d "," -f 1 | sed '/^$/d'`
ip=`echo $linha | cut -d "," -f 2 | sed '/^$/d'`
senha=`echo $linha | cut -d "," -f 3 | sed '/^$/d'`

distro=$(sshpass -p `echo $senha` ssh -o StrictHostKeyChecking=no $login@$ip cat /etc/issue)


	if [ $? -eq 0 ] ; then

	zenity --info --text "Acesso Concedido.... [ok] 

	Usuario => $login
	Ip => $ip
	Distribuição => $distro" 2>/dev/null

	else 

	zenity --error --text  "Erro no Acesso ..... [ok]" 2>/dev/null

	fi

	done
	;;


	"2")


	for linha in `cat $file 2>/dev/null`; do


	login=`echo $linha | cut -d "," -f 1 | sed '/^$/d'`
	ip=`echo $linha | cut -d "," -f 2 | sed '/^$/d'`
	senha=`echo $linha | cut -d "," -f 3 | sed '/^$/d'`

	echo "\t Servidor:=> $login - $ip"

	sshpass -p `echo $senha` ssh -o StrictHostKeyChecking=no $login@$ip 'bash -s' < script/functions.sh update 

	if [ $? -eq 0 ] ; then

	echo "Sistema:$login - $ip Atualizado [ok]"

	else 

	echo "Sistema:$login - $ip  Erro na Atualização [ok]$cp"
	fi

	done
	;;

	"3")

	for linha in `cat $file 2>/dev/null`; do

	login=`echo $linha | cut -d "," -f 1 | sed '/^$/d'`
	ip=`echo $linha | cut -d "," -f 2 | sed '/^$/d'`
	senha=`echo $linha | cut -d "," -f 3 | sed '/^$/d'`

	echo "\t Servidor:=> $login - $ip"

	sshpass -p `echo $senha` ssh -o StrictHostKeyChecking=no  $login@$ip 'bash -s' < script/functions.sh repo
	if [ $? -eq 0 ] ; then

	echo "Sistema:$login - $ip Dependencias Instaladas [ok]"

	else 

	echo "Sistema:$login - $ip  Erro ao Instalar dependencias [ok]"

	fi

	done
	;;


	"4")

	for linha in `cat $file 2>/dev/null`; do


	login=`echo $linha | cut -d "," -f 1 | sed '/^$/d'`
	ip=`echo $linha | cut -d "," -f 2 | sed '/^$/d'`
	senha=`echo $linha | cut -d "," -f 3 | sed '/^$/d'`
	dominio=`echo $linha | cut -d "," -f 4 | sed '/^$/d'` 


	echo "\tServidor:=> $login - $ip"

	sshpass -p `echo $senha` ssh -o StrictHostKeyChecking=no  $login@$ip 'bash -s' < script/functions.sh install $dominio

	if [ $? -eq 0 ] ; then

	echo "Sistema:$login - $ip Pacotes Instalados com Sucesso"
	else
	echo "Sistema:$login - $ip Erro na Instalação do Pacote ..... [ok]"

	fi

	done

	;;

	"5")


	for linha in `cat $file 2>/dev/null`; do

	login=`echo $linha | cut -d "," -f 1 | sed '/^$/d'`
	ip=`echo $linha | cut -d "," -f 2 | sed '/^$/d'`
	senha=`echo $linha | cut -d "," -f 3 | sed '/^$/d'`

	comand=`sshpass -p $(echo $senha) ssh -o StrictHostKeyChecking=no $login@$ip 'bash -s' < script/functions.sh vstatus | zenity --list --title "Pacotes Instalados" --column "Server:$login - $ip" --separator=" " --multiple --width=750 --height=500` 2>/dev/null

	for i in ${comand}; do

	echo ${i}

	done

	if [ $? -eq 0 ] ; then

	echo "Acesso Concedido.... [ok]"

	else 

	echo "Erro no Acesso ..... [ok]"
	fi

	done

	;;

	"6")

	echo ok

	;;

	"7")

	import=$(zenity  --title="Selecione o Arquivo para Importação" --file-selection) 2> /dev/null

	for linha in `cat $file`; do

	login=`echo $linha | cut -d "," -f 1 | sed '/^$/d'`
	ip=`echo $linha | cut -d "," -f 2 | sed '/^$/d'`
	senha=`echo $linha | cut -d "," -f 3 | sed '/^$/d'`

	cm=$(sshpass -p `echo $senha` ssh -o StrictHostKeyChecking=no $login@$ip 'bash -s' < script/functions.sh copy)
	sshpass -p `echo $senha` scp -o StrictHostKeyChecking=no $import $login@$ip:$cm | zenity --progress \
  --title="Update de arquivos" \
  --text="Transferindo --->" \
  --percentage=0 2> /dev/null

	if [ $? -eq 0 ] ; then

	zenity --info --text "Acesso Concedido.... [ok] 

	Usuario => $login
	Ip => $ip
	Distribuição => $cm" 2>/dev/null

	else 

	zenity --error --text  "Erro no Acesso ..... [ok]" 2>/dev/null

	fi

	done

	;;

	*) 

#zenity --error --text  "Opção desconhecida" 2>/dev/null
#exit 1
	;;
	esac







