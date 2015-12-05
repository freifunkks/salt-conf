include:
  - nginx

home.ffks:
  nginx_site.present:
    - conf: salt://nginx/configs/home.ffks

freifunk-kassel.de:
  nginx_site.present:
    - conf: salt://nginx/configs/home.ffks

ffks-home:
  user.present:
    - shell: /usr/bin/nologin

/srv/http/home.ffks:
  file.symlink:
    - target: /var/www/home.ffks/theme/wikistatic
    - require:
      - file: /srv/http
      - git: https://github.com/freifunkks/moinmoin-theme.git

extend:
  nginx:
    service:
      - watch:
        - nginx_site: home.ffks
        - nginx_site: freifunk-kassel.de

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
    - requre:
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
