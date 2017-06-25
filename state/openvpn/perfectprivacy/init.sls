# TODO
#/etc/openvpn/perfectprivacy.conf
#  file.managed:
#    - source: salt://openvpn/perfectprivacy.conf
#    - makedirs: True
#    - ...

/etc/systemd/system/openvpn@perfectprivacy.service.d/service.conf:
  file.managed:
    - makedirs: True
    - contents: |
        [Unit]
        Requires=fastd@ffks_vpn.service

/etc/openvpn/up.sh:
  file.managed:
    - source: salt://openvpn/up.sh
    - makedirs: True
    - mode: 755
    - template: jinja

/etc/openvpn/down.sh:
  file.managed:
    - source: salt://openvpn/down.sh
    - makedirs: True
    - mode: 755
    - template: jinja

openvpn@perfectprivacy:
  service.running:
    - enable: True
    - watch:
      - pkg: openvpn
      - file: /etc/systemd/system/openvpn@perfectprivacy.service.d/service.conf
      #- file: /etc/openvpn/perfectprivacy.conf
      - file: /etc/openvpn/up.sh
      - file: /etc/openvpn/down.sh
