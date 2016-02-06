fastd:
  pkgrepo.managed:
    - name: deb https://repo.universe-factory.net/debian/ sid main
    - humanname: fastd
    - dist: sid
    - file: /etc/apt/sources.list.d/fastd.list
    - refresh_db: true
    - keyid: CB201D9C
    - keyserver: pgp.mit.edu
    - order: 2
  pkg.installed:
    - order: 3
