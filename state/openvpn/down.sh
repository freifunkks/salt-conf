#!/bin/sh

openvpn_interface="tun0"
fastd_interface="ffks-vpn"

ip rule del from {{ pillar['minions'][grains['id']]['bat_ip'] }} table kassel priority 9970

iptables --table nat --remove POSTROUTING --out-interface "$openvpn_interface" -j MASQUERADE
