grafana:
  pkgrepo.managed:
    - name: deb https://packagecloud.io/grafana/stable/debian/ jessie main
    - humanname: grafana
    - dist: jessie
    - file: /etc/apt/sources.list.d/grafana.list
    - refresh: True
    - key_url: https://packagecloud.io/gpg.key
  pkg.installed:
    - require:
      - pkgrepo: grafana
  user.present:
    - shell: /usr/sbin/nologin
    - order: 11

# Freifunk Kassel
grafana_ffks:
  postgres_user.present: []
  postgres_database.present:
    - owner: grafana
    - owner_recurse: True

/etc/grafana/grafana-ffks.ini:
  file.managed:
    - source: salt://grafana/grafana.ini
    - template: jinja
    - require:
      - pkg: grafana
    - context:
      path: /var/lib/grafana-ffks/dashboards
      port: 10001
      db_name: grafana_ffks
      org_name: Freifunk Kassel

/var/lib/grafana-ffks/dashboards:
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
grafana_flipdot:
  postgres_user.present: []
  postgres_database.present:
    - owner: grafana
    - owner_recurse: True

/etc/grafana/grafana-flipdot.ini:
  file.managed:
    - source: salt://grafana/grafana.ini
    - template: jinja
    - require:
      - pkg: grafana
    - context:
      path: /var/lib/grafana-flipdot/dashboards
      port: 10011
      db_name: grafana_flipdot
      org_name: flipdot

grafana-flipdot:
  service.running:
    - enable: True
    - watch:
      - pkg: grafana
      - file: /etc/grafana/grafana-flipdot.ini

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

# Heatmap plugin
https://github.com/mtanda/grafana-heatmap-epoch-panel.git:
  git.latest:
    - target: /var/lib/grafana-flipdot/plugins/grafana-heatmap-epoch-panel

# Histogram plugin
https://github.com/mtanda/grafana-histogram-panel.git:
  git.latest:
    - target: /var/lib/grafana-flipdot/plugins/grafana-histogram-panel
