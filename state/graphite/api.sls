include:
  - nginx
  - uwsgi

python-pip: pkg.installed
graphite-api-deps:
  pkg.installed:
    - pkgs:
      - libffi-dev
      - python-dev

graphite-api:
  user.present:
    - shell: /usr/sbin/nologin
  pip.installed:
    - require:
      - pkg: python-pip

graphite.freifunk-kassel.de:
  nginx_site.present_le:
    - configfile: salt://graphite/graphite-api.nginx-conf
    - server_names:
      - graphite.freifunk-kassel.de
      - graphite.{{ grains.host }}.ffks.de
    - watch_in:
      - service: nginx

/etc/uwsgi/apps-available/graphite-api.ini:
  file.managed:
    - source: salt://graphite/graphite-api.uwsgi-ini
    - mode: 644
    - require:
      - pip: graphite-api
    - watch_in:
      - service: uwsgi

/etc/uwsgi/apps-enabled/graphite-api.ini:
  file.symlink:
    - target: /etc/uwsgi/apps-available/graphite-api.ini
    - require:
      - file: /etc/uwsgi/apps-available/graphite-api.ini
    - watch_in:
      - service: uwsgi

/srv/graphite:
  file.directory:
    - user: graphite-api
    - group: graphite-api
    - mode: 755

/srv/graphite/whisper:
  file.symlink:
    - target: /var/lib/graphite/whisper
