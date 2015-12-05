include:
  - nginx

map.ffks:
  nginx_site.present:
    - conf: salt://nginx/configs/map.ffks

map.freifunk-kassel.de:
  nginx_site.present:
    - conf: salt://nginx/configs/map.ffks

ffks-map:
  user.present:
    - createhome: False
    - shell: /usr/bin/nologin

/srv/http/map.ffks:
  file.symlink:
    - target: /var/www/map.ffks/
    - require:
      - file: /srv/http
      - cmd: /var/www/map.ffks/build

extend:
  nginx:
    service:
      - watch:
        - nginx_site: map.ffks
        - nginx_site: freifunk-kassel.de

/var/www/map.ffks:
  file.directory:
    - user: ffks-map
    - group: www-data
    - dir_mode: 755
    - file_mode: 644
    - recurse: [user, group, mode]

npm: pkg.installed

grunt:
  npm.installed:
    - require:
      - pkg: npm

https://github.com/freifunkks/meshviewer.git:
  git.latest:
    - target: /var/www/map.ffks
    - user: ffks-map
    - require:
      - file: /var/www/map.ffks
      - cmd: /var/www/map.ffks/build
  npm.bootstrap:
    - name: /var/www/map.ffks
    - user: ffks-map
    - require:
      - npm: grunt
    - watch:
      - git: https://github.com/freifunkks/meshviewer.git

/var/www/map.ffks/build:
  cmd.wait:
    # default tasks without lint, could potentially be shortened
    - name: grunt bower-install-simple saveRevision copy sass requirejs
    - cwd: /var/www/map.ffks
    - watch:
      - npm: https://github.com/freifunkks/meshviewer.git
