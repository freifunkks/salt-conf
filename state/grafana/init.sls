include:
  - postgresql

apt-transport-https: pkg.installed

grafana:
  pkgrepo.managed:
    - name: deb https://packagecloud.io/grafana/stable/debian/ jessie main
    - humanname: grafana
    - dist: jessie
    - file: /etc/apt/sources.list.d/grafana.list
    - refresh_db: true
    - key_url: https://packagecloud.io/gpg.key
    - require:
      - pkg: apt-transport-https
  pkg.installed:
    - require:
      - pkgrepo: grafana
  user.present:
    - shell: /usr/bin/nologin
    - order: 11
  postgres_user.present:
    - watch_in:
      - service: postgresql
  postgres_database.present:
    - watch_in:
      - service: postgresql

/etc/grafana/grafana.ini:
  file.managed:
    - source: salt://grafana/grafana.ini
    - create: False
    - require:
      - pkg: grafana

grafana-server:
  service.running:
    - enable: True
    - watch:
      - pkg: grafana
      - user: grafana
      - file: /etc/grafana/grafana.ini