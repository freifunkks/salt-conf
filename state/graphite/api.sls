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
  nginx_site.present:
    - configfile: salt://graphite/graphite-api.nginx-conf
    - address: localhost
    - port: 7003
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
