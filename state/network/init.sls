network:
  pkg.installed: []

/etc/network/interfaces.d/bat0:
  file.managed:
    - source: salt://network/bat0
    - template: jinja

/etc/network/interfaces.d/ffks_vpn:
  file.managed:
    - source: salt://network/ffks_vpn
    - template: jinja
