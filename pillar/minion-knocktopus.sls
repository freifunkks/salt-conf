minion:
  gateway: True
  network-interfaces:
    eth0:
      - enabled: True
      - type: eth
      - proto: static
      - ipaddr: 141.51.228.5
      - netmask: 255.255.255.0
      - gateway: 141.51.228.1
      - dns:
        - 208.67.222.222
        - 208.67.220.220
    eth1:
      - enabled: True
      - type: eth
      - proto: static
      - ipaddr: 192.168.0.123
      - netmask: 255.255.255.0
