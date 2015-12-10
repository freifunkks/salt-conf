include:
  - nginx

home.ffks:
  nginx_site.present:
    - configfile: salt://nginx/configs/ffks-dl.nginx-conf
    - watch_in:
      - service: nginx

freifunk-kassel.de:
  nginx_site.present:
    - configfile: salt://nginx/configs/ffks-dl.nginx-conf
    - watch_in:
      - service: nginx

www.freifunk-kassel.de:
  nginx_site.redirect:
    - target: https://freifunk-kassel.de
    - watch_in:
      - service: nginx

ffks-home:
  user.present:
    - shell: /usr/bin/nologin
    - order: 11

/home/ffks-home/wikicontent:
  file.directory:
    - user: ffks-home
    - group: www-data
    - dir_mode: 755
    - file_mode: 644
    - recurse: [user, group, mode]

/home/ffks-home/wikiconfig.py:
  file.managed:
    - source: salt://nginx/configs/ffks-dl.wikiconfig.py
    - user: ffks-home
    - group: www-data
    - mode: 644

/home/ffks-home/moin.wsgi:
  file.managed:
    - source: salt://nginx/configs/ffks-home.wsgi
    - user: ffks-home
    - group: www-data
    - mode: 644

uwsgi:
  pkg.installed:
    - pkgs:
      - uwsgi
      - uwsgi-plugin-python
  service.running:
    - enable: True
    - watch:
      - pkg: uwsgi
      - file: /home/ffks-home/moin.wsgi

/etc/uwsgi/apps-available/ffks-home.ini:
  file.managed:
    - source: salt://nginx/configs/ffks-home.uwsgi-ini
    - mode: 644
    - require:
      - pkg: uwsgi

/etc/uwsgi/apps-enabled/ffks-home.ini:
  file.symlink:
    - target: /etc/uwsgi/apps-available/ffks-home.ini
    - require:
      - file: /etc/uwsgi/apps-available/ffks-home.ini
    - watch_in:
      - service: uwsgi

python-moinmoin: pkg.installed

https://github.com/freifunkks/moinmoin-theme.git:
  git.latest:
    - target: /home/ffks-home/theme
    - user: ffks-home

https://github.com/freifunkks/moinmoin-plugins.git:
  git.latest:
    - target: /home/ffks-home/plugins
    - user: ffks-home