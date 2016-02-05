dnsmasq:
  pkg.installed: []

/etc/dnsmasq.d/shared:
  file.managed:
    - source: salt://dnsmasq/shared
    - require:
      - pkg: dnsmasq

/etc/dnsmasq.d/dns:
  file.managed:
    - source: salt://dnsmasq/dns
    - require:
      - pkg: dnsmasq

/etc/dnsmasq.d/dhcp:
  file.managed:
    - source: salt://dnsmasq/dhcp
    - template: jinja
    - require:
      - pkg: dnsmasq
