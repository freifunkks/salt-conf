#!/bin/sh

openvpn_interface="tun0"

ip route del table ffks default

ip rule del priority 109 iif lo table main
ip rule del priority 110 from 10.54.0.0/16 table ffks

iptables --table nat --delete POSTROUTING --out-interface $openvpn_interface -j MASQUERADE
