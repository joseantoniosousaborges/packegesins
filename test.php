<?php
$serverHost = 'sgi.grupoferraz.com.br';
$serverUser = 'root';
$serverPass = '@@gpferraz#';

/* Faz a conexão com o servidor remoto */
if (!$ssh = @ssh2_connect($serverHost, 22)) {
    echo "Erro ao se conectar com o servidor...\n";
    exit();
}

/* Faz a autenticação no servidor remoto */
if (!@ssh2_auth_password($ssh, $serverUser, $serverPass)) {
    echo "Erro ao efetuar autenticação no servidor remoto...\n";
    exit();
}else {


echo @ssh2_exec('ls -l');

}



 

?>
