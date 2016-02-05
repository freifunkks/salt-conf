dnsmasq:

/etc/dnsmasq.d/shared:
  file.managed:
    source: salt://dnsmasq/shared

/etc/dnsmasq.d/dns:
  file.managed:
    source: salt://dnsmasq/dns

/etc/dnsmasq.d/dhcp:
  file.managed:
    source: salt://dnsmasq/dhcp
    template: jinja
