openvpn:

/etc/openvpn/uplink/up.sh:
  file.managed:
    - source: salt://openvpn/up.sh
    - makedirs: True
    - template: jinja

/etc/openvpn/uplink/down.sh:
  file.managed:
    - source: salt://openvpn/down.sh
    - makedirs: True
    - template: jinja
