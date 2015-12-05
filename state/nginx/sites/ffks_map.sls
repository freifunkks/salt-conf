include:
  - nginx

map.ffks:
  nginx_site.present:
    - configfile: salt://nginx/configs/map.ffks

map.freifunk-kassel.de:
  nginx_site.present:
    - configfile: salt://nginx/configs/map.ffks

ffks-map:
  user.present:
    - createhome: False
    - shell: /usr/bin/nologin

/srv/http/map.ffks:
  file.symlink:
    - target: /var/www/map.ffks/build
    - require:
      - file: /srv/http
      - cmd: /var/www/map.ffks/build

extend:
  nginx:
    service:
      - watch:
        - nginx_site: map.ffks
        - nginx_site: map.freifunk-kassel.de

/var/www/map.ffks:
  file.directory:
    - user: ffks-map
    - group: www-data
    - dir_mode: 755
    - file_mode: 644
    - recurse: [user, group, mode]

node:
  pkg.installed:
    - pkgs:
      # Legacy symlink, grunt needs this
      - nodejs-legacy
      - npm

ruby-sass: pkg.installed

grunt-cli:
  npm.installed:
    - require:
      - pkg: node

https://github.com/freifunkks/meshviewer.git:
  git.latest:
    - rev: community-specific-adjustments
    - target: /var/www/map.ffks
    - user: ffks-map
    - require:
      - file: /var/www/map.ffks
  npm.bootstrap:
    - name: /var/www/map.ffks
    - user: ffks-map
    - require:
      - npm: grunt-cli
    - watch:
      - git: https://github.com/freifunkks/meshviewer.git

/var/www/map.ffks/build:
  cmd.wait:
    # default tasks without lint, could potentially be shortened
    - name: grunt bower-install-simple saveRevision copy sass requirejs && cp config.json build/
    - cwd: /var/www/map.ffks
    - watch:
      - npm: https://github.com/freifunkks/meshviewer.git
      - pkg: ruby-sass
