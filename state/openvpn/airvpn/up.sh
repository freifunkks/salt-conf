#!/bin/sh

openvpn_interface="tun0"
fastd_interface="ffks-vpn"

ip route add table ffks default via {{ pillar['minions'][grains['id']]['openvpn_gw'] }}
ip route add table ffks {{ pillar['minions'][grains['id']]['bat_ip'] }} dev bat0
ip rule  add table ffks from {{ pillar['minions'][grains['id']]['openvpn_net'] }} to {{ pillar['minions'][grains['id']]['bat_ip'] }}/16

ip rule  add table ffks from {{ pillar['minions'][grains['id']]['bat_ip'] }} priority 9970
ip route add table ffks 128.0.0.0/1 via eth0 dev $openvpn_interface

ip route flush cache

# enable packet forwarding to function s a router
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables --append FORWARD --in-interface "$fastd_interface" -j ACCEPT
# Enable MASQUERADE to function as a NAT router
iptables --table nat --append POSTROUTING --out-interface "$openvpn_interface" -j MASQUERADE
