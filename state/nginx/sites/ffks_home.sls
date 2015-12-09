include:
  - nginx

home.ffks:
  nginx_site.present:
    - configfile: salt://nginx/configs/home.ffks.nginx-conf
    - watch_in:
      - service: nginx

freifunk-kassel.de:
  nginx_site.present:
    - configfile: salt://nginx/configs/home.ffks.nginx-conf
    - watch_in:
      - service: nginx

www.freifunk-kassel.de:
  nginx_site.redirect:
    - target: https://freifunk-kassel.de
    - watch_in:
      - service: nginx

ffks-home:
  user.present:
    - createhome: False
    - shell: /usr/bin/nologin

/srv/http/home.ffks:
  file.symlink:
    - target: /var/www/home.ffks/theme/wikistatic
    - require:
      - file: /srv/http
      - git: https://github.com/freifunkks/moinmoin-theme.git

/var/www/home.ffks:
  file.directory:
    - user: ffks-home
    - group: www-data
    - dir_mode: 755
    - file_mode: 644
    - recurse: [user, group, mode]

/var/www/home.ffks/wikicontent:
  file.directory:
    - user: ffks-home
    - group: www-data
    - dir_mode: 755
    - file_mode: 644
    - recurse: [user, group, mode]

/var/www/home.ffks/wikiconfig.py:
  file.managed:
    - source: salt://nginx/configs/home.ffks.wikiconfig.py
    - user: ffks-home
    - group: www-data
    - mode: 644

/var/www/home.ffks/moin.wsgi:
  file.managed:
    - source: salt://nginx/configs/home.ffks.wsgi
    - user: ffks-home
    - group: www-data
    - mode: 644

uwsgi:
  pkg.installed: []
  service.running:
    - watch:
      - pkg: uwsgi
      - file: /var/www/home.ffks/moin.wsgi

/etc/uwsgi/apps-available/home.ffks.ini:
  file.managed:
    - source: salt://nginx/configs/home.ffks.uwsgi-ini
    - mode: 644
    - require:
      - pkg: uwsgi

/etc/uwsgi/apps-enabled/home.ffks.ini:
  file.symlink:
    - target: /etc/uwsgi/apps-available/home.ffks.ini
    - require:
      - file: /etc/uwsgi/apps-available/home.ffks.ini

python-moinmoin: pkg.installed

https://github.com/freifunkks/moinmoin-theme.git:
  git.latest:
    - target: /var/www/home.ffks/theme
    - user: ffks-home
    - require:
      - file: /var/www/home.ffks

https://github.com/freifunkks/moinmoin-plugins.git:
  git.latest:
    - target: /var/www/home.ffks/plugins
    - user: ffks-home
    - require:
      - file: /var/www/home.ffks
