grafana:
  pkgrepo.managed:
    - name: deb https://packagecloud.io/grafana/stable/debian/ jessie main
    - humanname: grafana
    - dist: jessie
    - file: /etc/apt/sources.list.d/grafana.list
    - refresh_db: True
    - key_url: https://packagecloud.io/gpg.key
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
  file.recurse:
    - source: salt://grafana/dashboards
    - clean: True
    - dir_mode: 755
    - user: grafana
    - group: grafana
    - require:
      - pkg: grafana
      - user: grafana

/usr/share/grafana/public/img/fav32.png:
  file.managed:
    - source: salt://grafana/fav32.png
    - create: False

/usr/share/grafana/public/dashboards/home.json:
  file.managed:
    - source: salt://grafana/home.json
    - create: False

grafana-server:
  service.running:
    - enable: True
    - watch:
      - pkg: grafana
      - file: /etc/grafana/grafana.ini
      - file: /var/lib/grafana/dashboards
