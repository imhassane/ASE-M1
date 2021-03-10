#!/bin/bash

. ../original_files/functions

config_file="/etc/sysconfig/network-scripts/ifcfg-enp0s3"

function update_config_file() {
	if [ `exist $config_file $1` -eq 0 ]
	then
		replace_line $config_file $1 $2
	else
		add_line $config_file $2
	fi
}

if (( $# == 1 ))
then
	if grep -q "$1" ./machines; then
	
		ip=$(grep $1 ./machines | cut -d ' ' -f 1)
		reseau=$(grep IF ./param | cut -d '=' -f 2 )
		
		
		ifconfig $reseau $ip
		
		update_config_file BOOTPROTO "BOOTPROTO=none"
		
		update_config_file IPADDR "IPADDR=${ip}"
		
		update_config_file GATEWAY "GATEWAY=192.168.56.100"
		
		update_config_file PREFIX "PREFIX=24"
		
		IFS=$'\n'
		
		domain_ip=$(grep DOMAINE_IP ./param | cut -d '=' -f 2)
		machine_list=$(grep MACHINE_LIST ./param | cut -d '=' -f 2)
		
		for a in `cat $machine_list`
		do
			network_name=$(echo $a | cut -d ' ' -f 2)
			domain_ip=$(echo $domain_ip | cut -d '"' -f 2)
			
			add_line /etc/hosts "${a} ${network_name}.${domain_ip}"
		done
		
		hostname $1
		echo $1 > /etc/hostname
	else
		echo "La machine n'existe pas"
		exit 1
	fi
else
	echo "Un seul paramètre doit être fourni"
	exit 1
fi

