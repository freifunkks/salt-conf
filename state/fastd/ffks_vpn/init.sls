include:
  - fastd.ffks_vpn.service

/etc/fastd/ffks_vpn/fastd.conf:
  file.managed:
    - source: salt://fastd/ffks_vpn/ffks_vpn.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - makedirs: True
    - require:
      - pkg: fastd
    - watch_in:
      - service: fastd@ffks_vpn

/etc/fastd/ffks_vpn/gateways:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - require:
      - pkg: fastd

/etc/network/interfaces.d/ffks_vpn:
  file.managed:
    - source: salt://network/ffks_vpn
    - template: jinja
