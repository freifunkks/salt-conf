include:
  - nginx

home.ffks:
  nginx_site.present:
    - configfile: salt://nginx/configs/home.ffks
    - watch_in:
      - service: nginx

freifunk-kassel.de:
  nginx_site.present:
    - configfile: salt://nginx/configs/home.ffks
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

hg: pkg.installed

https://bitbucket.org/thomaswaldmann/moin-1.9:
  hg.latest:
    - target: /var/www/home.ffks/moinmoin
    - user: ffks-home
    - require:
      - file: /var/www/home.ffks

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
