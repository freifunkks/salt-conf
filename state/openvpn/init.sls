openvpn:
  pkg.installed:
    - order: 2

# Either airvpn or perfectprivacy
include:
  - openvpn.{{ pillar.minions[grains.id].gw_vpn }}

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
