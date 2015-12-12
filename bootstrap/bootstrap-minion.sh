#!/bin/bash
## ffks-salt-setup.sh
## Sets up a salt minion gateway / web server
## by installing salt and setting up unused host name
#
## Make sure script is run as root
#if [[ $EUID -ne 0 ]]; then
#	echo "Please run this script as root" 1>&2
#	exit 1
#fi
#
## Install Saltstack from official repo
#https://repo.saltstack.com/apt/debian/8/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -
#echo "deb http://repo.saltstack.com/apt/debian/8/amd64/latest jessie main" >> /etc/apt/sources.list.d/saltstack
#apt-get update
#apt-get install -y salt-minion
#
## TODO
## Alternatively use community repo
## deb http://debian.saltstack.com/debian jessie-saltstack main
#
## Use masterless local minion mode
## if not already set
#minion_file=/etc/salt/minion
#minion_local="file_client: local"
#grep ${minion_local} ${minion_file} 1>/dev/null && echo "Local minion mode already enabled." || ( sed -i "/#file_client: remote/a ${minion_local}" ${minion_file}; echo "Enabled local minion mode." )
#
## Install hostname selection prerequisites
#apt-get install -y python-pip
#pip install shyaml

# Dialog options
export DIALOGRC="$PWD/dialogrc"
minion_list="$PWD/testminions.yaml"
dialog_choice=$(mktemp)
dialog_min=7
domain_inner="ffks"
domain_outer="${domain_inner}.de"

# Select minion's role
# (Gateway / webserver)

function select_server_role() {
	roles_dialog=$(cat ${minion_list} | shyaml keys | sed = | sed 's/s$//' | sed -r 's/^([a-z])/\U\1/' | sed ':a;N;$!ba;s/\n/ /g')
	roles_num=$(cat ${minion_list} | shyaml keys | wc -l)
	dialog --menu "Select server role:" $((7+${roles_num})) 23 ${roles_num} ${roles_dialog} 2> ${dialog_choice}
	roles_choice=$(<"${dialog_choice}")
	role=$(cat ${minion_list} | shyaml keys | sed -n ${roles_choice}p)
	select_server_hostname
}

function select_server_hostname() {
	# Select hostname from gateways / webservers
	hostnames_dialog=$(cat ${minion_list} | shyaml get-values ${role} | sed = | sed 's/s$//' | sed ':a;N;$!ba;s/\n/ /g')
	hostnames_num=$(cat ${minion_list} | shyaml get-values ${role} | wc -l)
	dialog --menu "Select servers hostname:" $((${dialog_min}+${hostnames_num})) 29 ${hostnames_num} ${hostnames_dialog} 2> ${dialog_choice}
	hostnames_choice=$(<"${dialog_choice}")
	hostname=$(cat ${minion_list} | shyaml get-values ${role} | sed -n ${hostnames_choice}p)

	# Check if hostname is already in use
	# TODO Check network connectivity beforehand?
	ping -W 2 -c1 ${hostname}.${domain_outer} 2>1 >/dev/null && ( dialog --msgbox "Hostname seems to be already in use. Please select another one." 6 40; select_server_hostname ) || dialog --msgbox "Hostname seems to be free. Starting salt setup now." 6 30
}

if [[ -z $1 ]]; then
	select_server_role
else
	# TODO Unfuck variable scope
	hostname="$1"
	cat ${minion_list} | grep -c "^\s*\- ${hostname}$" >/dev/null || ( dialog --msgbox "Hostname (${hostname}) is not available within salt repository. Please choose another one." 6 $((44+${#hostname})); select_server_role )
	ping -W 2 -c1 ${hostname}.${domain_outer} 2>1 >/dev/null && ( dialog --msgbox "Hostname seems to be already in use. Please select another one." 6 40; select_server_role )
	echo ${hostname}.${domain_outer}
fi

echo ${hostname}.${domain_outer}

# Remove dirt
[ -f ${dialog_choice} ] && rm ${dialog_choice}

