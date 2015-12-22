#!/bin/bash
# ffks-salt-setup.sh
# Sets up a salt minion gateway / web server
# by installing salt and setting up unused host name

# Make sure script is run as root
if [[ $EUID -ne 0 ]]; then
	echo "Please run this script as root" 1>&2
	exit 1
fi

# Change working directory to script's
cd "$(dirname "$0")"

echo "Bootstrapping minion..."
echo

# Colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
cyan='\033[0;36m'
nc='\033[0m' # no color

ok="[ ${green}OK${nc} ]"
noy="[ ${yellow}NO${nc} ]"
err="[ ${red}ERROR${nc} ]"
info="[ ${cyan}INFO${nc} ]"

# Check official salt repo
declare -a repo_names=(saltstack-official)
declare -a repo_lines=('deb http://repo.saltstack.com/apt/debian/8/amd64/latest jessie main')
declare -a repo_keys=('https://repo.saltstack.com/apt/debian/8/amd64/latest/SALTSTACK-GPG-KEY.pub')
declare -a repo_fingerprints=('2048R/DE57BFBE')

# Alternatively use community repo
#declare -a repo_names=(saltstack-community)
#declare -a repo_lines=('deb http://debian.saltstack.com/debian jessie-saltstack main')
#declare -a repo_keys=('???')
#declare -a repo_fingerprints=('???')

echo "Checking required repositories..."
i=0
for r in "${repo_lines[@]}"; do
	echo -n "  "
	if [[ $(grep -r "${r}" /etc/apt/sources.list*) ]]; then
		echo -ne "${ok}"
	else
		echo -ne "${noy}"
		repo_new+=($i)
	fi
	echo " ${repo_names[$i]}"
	((i++))
done
echo

[[ ${#repo_new[@]} -gt 0 ]] && echo "Adding required repositories..."
for i in "${repo_new[@]}"; do
	echo "  ${repo_names[$i]}:"
	# Add key if needed
	if [[ ! $(apt-key list | grep "${repo_fingerprints[$i]}") ]]; then
		wget -qO - "${repo_keys[$i]}" | apt-key add - && echo -e "    ${ok} Key added" || (echo -e "    ${err} Error adding key for repo ${repo_names[$i]}" 1>&2; exit 2)
	else
		echo -e "    ${ok} Key already available"
	fi
	grep -r "${repo_lines[$i]}" /etc/apt/sources.list* &>/dev/null || (echo -e "    ${ok} Repository added"; echo ${repo_lines[$i]} > /etc/apt/sources.list.d/${repo_names[$i]}.list) && echo -e "    ${ok} Repository already available"
done
[[ ${#repo_new[@]} -gt 0 ]] && echo

# Check system packages
declare -a pkg_req=(salt-minion python-pip git)

echo "Updating repositories..."
[[ $(apt-get update 1>/dev/null 2> >(wc -l)) -gt 0 ]] && (echo "Error updating repositories..." 1>&2; exit 3)
echo

echo "Checking installed system packages..."
for p in ${pkg_req[@]}; do
	echo -n "  "
	if [[ $(dpkg-query -W $p 2>/dev/null) ]]; then
		echo -ne "${ok}"
	else
		echo -ne "${noy}"
		pkg_new+=($p)
	fi
	echo " $p"
done
echo

if [[ ${#pkg_new[@]} -gt 0 ]]; then
	echo "Installing required system packages..."
	apt-get install -y ${pkg_new[@]} &>/dev/null || (echo -e "  ${err} Error installing required packages" 1>&2; exit 4)
	echo
fi

# Check python modules
declare -a py_req=(shyaml)

echo "Checking installed python modules..."
for p in ${py_req[@]}; do
	echo -n "  "
	if [[ $(pip show ${p}) ]]; then
		echo -ne "${ok}"
	else
		echo -ne "${noy}"
		py_new+=($p)
	fi
	echo " $p"
done
echo

if [[ ${#py_new[@]} -gt 0 ]]; then
	echo "Installing required python modules..."
	pip2 install ${py_new}
	echo
fi

# Use masterless local minion mode if not already set
echo "Configuring salt..."

minion_file=/etc/salt/minion
minion_local="file_client: local"
grep "${minion_local}" ${minion_file} &>/dev/null && echo -e "  ${ok} Local minion mode already enabled" || ( sed -i "/#file_client: remote/a ${minion_local}" ${minion_file}; echo -e "  ${ok} Enabled local minion mode" )
echo

# Clone salt-conf repo
cd /root
[[ -d salt-conf ]] || (echo "Getting 'Freifunk Kassel' salt configuration via git..."; git clone https://github.com/freifunkks/salt-conf.git)
[[ -d /srv ]] || mkdir /srv
[[ -L /srv/salt ]] || ln -s /root/salt-conf/state /srv/salt

echo "Setting up minion..."

minion_pre="$PWD/../pillar/minion-"
domain_inner="ffks"
domain_outer="${domain_inner}.de"

for i in ${minion_pre}*; do
	minion_list+=($(echo "$i" | sed 's|'${minion_pre}'\(\w\+\)\.sls|\1|'))
done

function choose_hostname() {
	echo "  Choose available hostname:"

	i=1
	for l in ${minion_list[@]}; do
		echo -e "   ${cyan}$i${nc}: $l"
		((i++))
	done
	echo

	echo -ne "    Hostname: ${cyan}"
	read minion_id
	((minion_id--))
	echo -e "${nc}"

	# Check if hostname is already in use

	h="${minion_list[$minion_id]}.${domain_outer}"
	s="${h} has address "
	ip_dns=$(host ${h} | grep "${s}" | sed "s/${s}//")
	ip_local=$(ip -o addr | awk '!/^[0-9]*: ?lo|link\/ether/ {print $4}' | grep -v : | sed 's/\([0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}\).*/\1/')

	minion_yaml="${minion_pre}${minion_list[$minion_id]}.sls"

	if [[ $minion_id =~ ^-?[0-9]+$ && $minion_id -lt ${#minion_list[@]} && $minion_id -ge 0 ]]; then
		# Check if the IP resolved via DNS is contained within the set of local IPs
		if [[ $(cat ${minion_yaml} | shyaml get-value minion.gateway) == "True" ]]; then
			echo -e "    ${info} ${minion_list[$minion_id]} is a gateway\n"
		else
			echo -e "    ${info} ${minion_list[$minion_id]} seems to be a web server\n"
		fi
		if [[ ${ip_dns} == *"${ip_local}"* ]]; then
			#if [[ ! $(ping -W 2 -c1 ${minion_list[$minion_id]}.${domain_outer} ) ]]; then
			echo -e "    ${ok} ${minion_list[$minion_id]} chosen without conflicts"
		else
			echo -e "    ${err} ${minion_list[$minion_id]} has the wrong IP address"
			echo "              local interface: ${ip_local}"
			echo "              DNS resolution:  ${ip_dns}"
			echo
			echo -ne "              Choose anyways? (${green}y${nc}/${red}N${nc}) ${cyan}"
			read override
			echo -e "${nc}"

			if [[ "$override" == "y" ]]; then
				return $minion_id
			fi
			choose_hostname
		fi
	else
		echo -e "    ${err} Your input was not valid\n"
		choose_hostname
	fi
}

choose_hostname
hostname=${minion_list[$?]}.${domain_inner}

# Change hostname in running session
sysctl kernel.hostname="${hostname}" &>/dev/null
# Make the change permanent
echo ${hostname} > /etc/hostname

# Salt's first run
echo -e "\nSalt is taking over now...\n"
salt-call state.highstate 2>/dev/null

# Reload new hostname in newly opened shell
exec ${SHELL}

