#!/bin/bash

# Autor: Michael Christian
# Versao: 1.0
# GitHub: mchristian279
# Centos 7.8 Minimum Install
# Cloudera Manager Versao - 5.16.2

configReposCloudera() {

    echo "Configurando Repositorio Cloudera Manager..." 

    repositoryDistro="/etc/yum.repos.d/"
    clouderaManagerRepo="https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/cloudera-manager.repo"
    addressClouderaRepo="archive.cloudera.com"

    grep -i "$addressClouderaRepo" /etc/yum.repos.d/*

    if [[ $? != 0 ]]; then
        
        wget $clouderaManagerRepo -P $repositoryDistro;

            echo "Repositorio configurado com sucesso!" 

    else
        echo "Erro ao configurar o Repositorio!" 
        
        exit
    fi

}

installTools(){

    echo "Instalando Utilitarios" 

    packages=(wget curl vim systat net-tools bash-completion bash-completion-extras)

    for installPackages in "${packages[@]}";

    do
        yum install $installPackages -y ;
        echo "Pacote Instalado: $installPackages" 
    done;

    source /etc/profile.d/bash_completion.sh  

}

setHostname(){

    echo "Configurando Hostname" 

    echo "Digite o nome do Hostname desejado:"
    read getHostname

    hostnamectl set-hostname $getHostname;

    echo "Hostname Configurado: $getHostname" 

}

firewallRules(){

    echo "Configurando Regras de Firewall"  

    ports=(7180 7181 7182 9000 9001 9002 7432 9083 9092 9093)

    for setPorts in "${ports[@]}";

    do
    
        firewall-cmd --permanent --add-port=$setPorts/tcp;
        
        echo "Porta de firewall configurado com sucesso: $setPorts" 
    
    done;

    firewall-cmd --reload
}

configNic() {

    echo "Iniciando Configuracoes de rede..." 

    fileConfigInteface="/etc/sysconfig/network-scripts/ifcfg-eth0"
    deleteBootProtoTypeDhcp=$(sed -i '/BOOTPROTO/d' /etc/sysconfig/network-scripts/ifcfg-eth0)


    echo "Informe o IP do servidor:"
    read ipServer
    echo "Informe o prefixo da rede. Exemplo:24"
    read prefixNetwork
    echo "Informe o Gateway:"
    read gatewayNetwork
    echo "Informe o DNS da rede:"
    read dns

    $deleteBootProtoTypeDhcp;
    sleep 2;
    echo BOOTPROTO=\"static\" >> $fileConfigInteface;
    echo IPADDR=\"$ipServer\" >> $fileConfigInteface;
    echo PREFIX=\"$prefixNetwork\" >> $fileConfigInteface;
    echo GATEWAY=\"$gatewayNetwork\" >> $fileConfigInteface;
    echo DNS1=\"$dns\" >> $fileConfigInteface;

    echo "Configuracao realizada" 

    tail -5 $fileConfigInteface

}

disableSeLinux() {

    echo "Desabilitando SELinux..." 

    hostname=$(hostname)
    dirConfigSeLinux="/etc/selinux/config"
    seLinuxStatus=$(sestatus | grep -i "SELinux status" | cut -d ':' -f 2)

    if [ $seLinuxStatus == enabled ]; then

        sed -i 's/enforcing/disabled/g' $dirConfigSeLinux;
        echo "SELinux Desabilitado com Sucesso!"

    else
        echo "SELinux Desabilitado!"
        $seLinuxStatus 

    fi

}

rebootHost(){

    echo "ATENCAO!!! sera realizado o reboot do servidor para as configuracoes entrarem em vigor!"
    echo "Apos o reboot o Script sera executado para terminar a configuracao. Aguarde..."
    
    sleep 15;
    init 6
}

deployConfigs(){
   
    if [ ! -f ~/flag ]; then
    setHostname;
    configNic;
    disableSeLinux;
    scriptConfig="bash ~/configHost.sh"
    echo "$scriptConfig" >> ~/.bashrc;
    touch ~/flag;
    rebootHost

    else
        echo "Executando configuracoes finais! Aguarde..."
        sleep 3;
        sed -i '13d' ~/.bashrc;
        rm -f ~/flag;
        firewallRules;
        installTools;
        configReposCloudera

    fi

}

deployConfigs
