#!/bin/sh

openvpn_interface="tun0"
fastd_interface="ffks-vpn"

ip rule del table ffks from {{ pillar.minions[grains.id].bat_ip }} priority 9970

iptables --table nat --delete POSTROUTING --out-interface "$openvpn_interface" -j MASQUERADE
