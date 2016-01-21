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
    - shell: /usr/sbin/nologin
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
    - force_fetch: True
    - force_reset: True
    - user: ffks-map

/home/ffks-map/meshviewer:
  npm.bootstrap:
    - user: ffks-map
    - require:
      - npm: grunt-cli

/home/ffks-map/meshviewer/build:
  cmd.wait:
    # default tasks without lint, could potentially be shortened
    - name: grunt bower-install-simple saveRevision copy sass requirejs
    - cwd: /home/ffks-map/meshviewer
    - user: ffks-map
    - watch:
      - git: https://github.com/freifunkks/meshviewer.git
      - npm: /home/ffks-map/meshviewer
      - pkg: ruby-sass

/home/ffks-map/meshviewer/build/config.json:
  file.managed:
    - source: salt://nginx/configs/ffks-map.config.json
    - user: ffks-map
    - group: ffks-map
    - mode: 644
    - makedirs: True
    - require:
      - npm: /home/ffks-map/meshviewer
