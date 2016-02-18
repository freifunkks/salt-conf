include:
  - openvpn

# TODO
#/etc/openvpn/airvpn.conf
#  file.managed:
#    - source: salt://openvpn/airvpn.conf
#    - makedirs: True
#    - ...

/etc/openvpn/airvpn/route-up.sh:
  file.managed:
    - source: salt://openvpn/airvpn/route-up.sh
    - makedirs: True
    - template: jinja

/etc/openvpn/airvpn/down.sh:
  file.managed:
    - source: salt://openvpn/airvpn/down.sh
    - makedirs: True
    - template: jinja

openvpn@airvpn:
  service.running:
    - enable: True
    - watch:
      - pkg: openvpn
      #- file: /etc/openvpn/airvpn.conf
      - file: /etc/openvpn/airvpn/up.sh
      - file: /etc/openvpn/airvpn/down.sh
