include:
  - fastd.ffks_vpn.service

https://github.com/freifunkks/fastd-keys.git:
  git.latest:
    - target: /etc/fastd/ffks_vpn/nodes
    - force_fetch: True
    - force_reset: True
    - user: root
    - require:
      - pkg: fastd
    - watch_in:
      - service: fastd@ffks_vpn
