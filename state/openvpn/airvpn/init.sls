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
        Requires=fastd@ffks_vpn.service

openvpn@airvpn:
  service.running:
    - enable: True
    - watch:
      - pkg: openvpn
      - file: /etc/systemd/system/openvpn@airvpn.service.d/service.conf
      #- file: /etc/openvpn/airvpn.conf
      - file: /etc/openvpn/up.sh
      - file: /etc/openvpn/down.sh
