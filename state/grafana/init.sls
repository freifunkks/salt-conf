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

# Freifunk Kassel
/etc/grafana/grafana-ffks.ini:
  file.managed:
    - source: salt://grafana/grafana.ini
    - template: jinja
    - require:
      - pkg: grafana
    - context:
      path: /var/lib/grafana-ffks/dashboards
      port: 10001

/var/lib/grafana/dashboards/ffks:
  file.recurse:
    - source: salt://grafana/dashboards/ffks
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
    - source: salt://grafana/home-ffks.json
    - create: False

grafana-ffks:
  service.running:
    - enable: True
    - watch:
      - pkg: grafana
      - file: /etc/grafana/grafana-ffks.ini
      - file: /var/lib/grafana-ffks/dashboards

/etc/systemd/system/grafana-ffks.service:
  file.managed:
    - source: salt://grafana/grafana.service
    - template: jinja
    - makedirs: True
    - context:
      conf_file: /etc/grafana/grafana-ffks.ini
      pid_file: /tmp/grafana-ffks.pid
      log_dir: /var/log/grafana-ffks
      data_dir: /var/lib/grafana-ffks
      plugins_dir: /var/lib/grafana-ffks/plugins

/var/lib/grafana-ffks:
  file.directory:
    - user: grafana
    - group: grafana
    - mode: 755

# flipdot
/etc/grafana/grafana-flipdot.ini:
  file.managed:
    - source: salt://grafana/grafana.ini
    - template: jinja
    - require:
      - pkg: grafana
    - context:
      path: /var/lib/grafana-flipdot/dashboards
      port: 10011

/var/lib/grafana/dashboards/flipdot:
  file.recurse:
    - source: salt://grafana/dashboards/flipdot
    - clean: True
    - dir_mode: 755
    - user: grafana
    - group: grafana
    - require:
      - pkg: grafana
      - user: grafana

grafana-flipdot:
  service.running:
    - enable: True
    - watch:
      - pkg: grafana
      - file: /etc/grafana/grafana-flipdot.ini
      - file: /var/lib/grafana-flipdot/dashboards

/etc/systemd/system/grafana-flipdot.service:
  file.managed:
    - source: salt://grafana/grafana.service
    - template: jinja
    - makedirs: True
    - context:
      conf_file: /etc/grafana/grafana-flipdot.ini
      pid_file: /tmp/grafana-flipdot.pid
      log_dir: /var/log/grafana-flipdot
      data_dir: /var/lib/grafana-flipdot
      plugins_dir: /var/lib/grafana-flipdot/plugins

/var/lib/grafana-flipdot:
  file.directory:
    - user: grafana
    - group: grafana
    - mode: 755
