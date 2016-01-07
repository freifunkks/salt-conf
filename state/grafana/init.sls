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
    - shell: /usr/sbin/nologin
    - order: 11
  postgres_user.present: []
  postgres_database.present:
    - owner: grafana
    - owner_recurse: True

/etc/grafana/grafana.ini:
  file.managed:
    - source: salt://grafana/grafana.ini
    - template: jinja
    - create: False
    - require:
      - pkg: grafana

/var/lib/grafana/dashboards:
  file.directory:
    - user: grafana
    - group: grafana
    - mode: 755
    - require:
      - pkg: grafana
      - user: grafana

grafana-server:
  service.running:
    - enable: True
    - watch:
      - pkg: grafana
      - file: /etc/grafana/grafana.ini
      - file: /var/lib/grafana/dashboards
