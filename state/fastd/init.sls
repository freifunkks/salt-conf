include:
  - fastd.service

fastd:
  pkgrepo.managed:
    - name: deb https://repo.universe-factory.net/debian/ sid main
    - humanname: fastd
    - dist: sid
    - file: /etc/apt/sources.list.d/fastd.list
    - refresh_db: true
    - keyid: CB201D9C
    - keyserver: pgp.mit.edu
  pkg.installed:
    - require:
      - pkgrepo: fastd

/etc/fastd/peers: file.absent
/etc/fastd/ffks_vpn/peers: file.absent

/etc/fastd/ffks_vpn/fastd.conf:
  file.managed:
    - source: salt://fastd/ffks_vpn.conf
    - template: jinja
    - user: root
    - owner: root
    - mode: 600
    - makedirs: True
    - require:
      - pkg: fastd
    - watch_in:
      - service: fastd@ffks_vpn

/etc/fastd/ffks_vpn/gateways:
  file.directory:
    - user: root
    - owner: root
    - mode: 755
    - makedirs: True
    - require:
      - pkg: fastd

/etc/network/interfaces.d/ffks_vpn:
  file.managed:
    - source: salt://network/ffks_vpn
    - template: jinja
