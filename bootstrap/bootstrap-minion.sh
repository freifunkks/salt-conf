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
#apt-get install -y python-pip dialog
#pip2 install shyaml

# Dialog options
export DIALOGRC="$PWD/dialogrc"
minion_pre="$PWD/../pillar/minion-"
#minion_list=$(pre='pillar/minion-'; for i in ${pre}*; do echo $i | sed 's|'$pre'\(\w\+\)\.sls|\1:|'; cat $i | sed 's/^/  /'; done)
minion_list=$(for i in ${minion_pre}*; do echo $i | sed 's|'${minion_pre}'\(\w\+\)\.sls|\1|'; done)
dialog_choice=$(mktemp)
dialog_min=7
domain_inner="ffks"
domain_outer="${domain_inner}.de"

# Select minion's hostname and
# thus choosing it's role and packages

function dia_host_available () {
	dialog --msgbox "Hostname seems to be free. Starting salt setup now." 6 30
}

function dia_host_unavailable () {
	dialog --msgbox "Hostname (${1}) is not available within salt repository. Please choose another one." 6 $((44+${#1}))
}

function dia_host_already_used () {
	dialog --msgbox "Hostname seems to be already in use. Please select another one." 6 40
}

function select_server_host() {
	# Select hostname from gateways / webservers
	hostnames_dialog=$(echo "${minion_list}" | sed = | sed ':a;N;$!ba;s/\n/ /g')
	hostnames_num=$(echo "${minion_list}" | wc -l)
	echo ${hostnames_dialog} 
	echo ${hostnames_num}
	dialog --menu "Select servers hostname:" $((${dialog_min}+${hostnames_num})) 29 ${hostnames_num} ${hostnames_dialog} 2> ${dialog_choice}
	hostnames_choice=$(<"${dialog_choice}")
	hostname=$(echo "${minion_list}" | sed -n ${hostnames_choice}p)

	# Check if hostname is already in use
	ping -W 2 -c1 ${hostname}.${domain_outer} 2>1 >/dev/null && ( dia_host_already_used; select_server_host ) || dia_hostname_available
}

if [[ -z $1 ]]; then
	select_server_host
else
	# TODO Unfuck variable scope
	hostname="$1"
	echo "${minion_list}" | grep -c "^${hostname}$" >/dev/null || ( dia_host_unavailable ${hostname}; select_server_host )
	ping -W 2 -c1 ${hostname}.${domain_outer} 2>1 >/dev/null && ( dia_host_already_used; select_server_host )
	echo ${hostname}.${domain_outer}
fi

echo ${hostname}.${domain_outer}

# Remove dirt
[ -f ${dialog_choice} ] && rm ${dialog_choice}

