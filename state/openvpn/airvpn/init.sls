include:
  - openvpn

# TODO
#/etc/openvpn/airvpn.conf
#  file.managed:
#    - source: salt://openvpn/airvpn.conf
#    - makedirs: True
#    - ...

/etc/systemd/system/openvpn@airvpn.service.d/service.conf:
  file.managed:
    - makedirs: True
    - contents: |
        [Unit]
        Requires=ffks_vpn@fastd.service

/etc/openvpn/airvpn/route-up.sh:
  file.managed:
    - source: salt://openvpn/airvpn/route-up.sh
    - makedirs: True
    - mode: 755
    - template: jinja

/etc/openvpn/airvpn/down.sh:
  file.managed:
    - source: salt://openvpn/airvpn/down.sh
    - makedirs: True
    - mode: 755
    - template: jinja

openvpn@airvpn:
  service.running:
    - enable: True
    - watch:
      - pkg: openvpn
      - file: /etc/systemd/system/openvpn@airvpn.service.d/service.conf
      #- file: /etc/openvpn/airvpn.conf
      - file: /etc/openvpn/airvpn/route-up.sh
      - file: /etc/openvpn/airvpn/down.sh
