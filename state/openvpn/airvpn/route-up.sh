#!/bin/sh

openvpn_interface="tun0"
fastd_interface="ffks-vpn"

IFS=. read -r i1 i2 i3 i4 <<< $ifconfig_local
IFS=. read -r m1 m2 m3 m4 <<< $ifconfig_netmask
openvpn_net=$(printf "%d.%d.%d.%d" "$((i1 & m1))" "$((i2 & m2))" "$((i3 & m3))" "$((i4 & m4))")

ip route add table ffks default via $route_vpn_gateway
ip route add table ffks {{ pillar.minions[grains.id].bat_ip }} dev bat0
ip rule  add table ffks from $openvpn_net to {{ pillar.minions[grains.id].bat_ip }}/16

ip rule  add table ffks from {{ pillar.minions[grains.id].bat_ip }} priority 9970
ip route add table ffks 128.0.0.0/1 via $route_vpn_gateway

ip route flush cache

# enable packet forwarding to function s a router
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables --append FORWARD --in-interface $fastd_interface -j ACCEPT
# Enable MASQUERADE to function as a NAT router
iptables --table nat --append POSTROUTING --out-interface $openvpn_interface -j MASQUERADE
