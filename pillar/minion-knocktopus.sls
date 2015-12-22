minion:
  gateway: True
  network-interfaces:
    eth0:
      network.managed:
        - enabled: True
        - type: eth
        - proto: static
        - ipaddr: 141.51.224.198
        - netmask: 255.255.255.0
        - dns:
          - 208.67.222.222
          - 208.67.220.220
    eth1:
      network.managed:
        - enabled: True
        - type: eth
        - proto: static
        - ipaddr: 192.168.0.123
        - netmask: 255.255.255.0
