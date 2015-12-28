fastd:
  pkgrepo.managed:
    - name: deb http://repo.universe-factory.net/debian/ sid main
    - humanname: fastd
    - dist: sid
    - file: /etc/apt/sources.list.d/fastd.list
    - refresh_db: true
    - keyid: CB201D9C
    - keyserver: pgp.mit.edu
  pkg.installed:
    - require:
      - pkgrepo: fastd

/etc/fastd/ffks-vpn/fastd.conf:
  file.managed:
    - source: salt://fastd/ffks-vpn.conf
    - template: jinja
    - user: root
    - owner: root
    - mode: 600
    - require:
      - pkg: fastd

/etc/fastd/peers:
  file.directory:
    - user: root
    - owner: root
    - mode: 755
    - require:
      - pkg: fastd
