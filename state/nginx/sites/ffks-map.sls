include:
  - nginx

{% for site in ['map.ffks', 'map.freifunk-kassel.de', 'map.' + grains.host + '.ffks.de'] %}
{{ site }}:
  nginx_site.present:
    - configfile: salt://nginx/configs/ffks-map.nginx-conf
    - watch_in:
      - service: nginx
{% endfor %}

ffks-map:
  user.present:
    - shell: /usr/bin/nologin
    - order: 11

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
    - target: /home/ffks-map/meshviewer
    - user: ffks-map
  npm.bootstrap:
    - name: /home/ffks-map/meshviewer
    - user: ffks-map
    - require:
      - npm: grunt-cli
    - watch:
      - git: https://github.com/freifunkks/meshviewer.git

/home/ffks-map/meshviewer/build:
  cmd.wait:
    # default tasks without lint, could potentially be shortened
    - name: grunt bower-install-simple saveRevision copy sass requirejs && cp config.json build/
    - cwd: /home/ffks-map/meshviewer
    - watch:
      - npm: https://github.com/freifunkks/meshviewer.git
      - pkg: ruby-sass
