#!/bin/sh

openvpn_interface="tun0"
batman_interface="ffks-vpn"

ip route add table ffks default via $route_vpn_gateway

# Use default routes for local traffic
ip rule add priority 109 iif lo table main

# Use ffks table for traffic from ffks-vpn
ip rule add priority 110 from 10.54.0.0/16 table ffks

# enable packet forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables --append FORWARD --in-interface $batman_interface -j ACCEPT

# Enable MASQUERADE to function as a NAT router
iptables --table nat --append POSTROUTING --out-interface $openvpn_interface -j MASQUERADE
