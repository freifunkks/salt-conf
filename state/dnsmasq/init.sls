dnsmasq:
  pkg.installed: []
  service.running:
    - enable: True
    - reload: True
    - watch:
      - pkg: dnsmasq
      - file: /etc/dnsmasq.d/shared
      - file: /etc/dnsmasq.d/dns
      - file: /etc/dnsmasq.d/dhcp

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
