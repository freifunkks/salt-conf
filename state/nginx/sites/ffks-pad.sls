include:
  - nginx
  - nodejs

pad.ffks:
  nginx_site.reverse_proxy:
    - target: http://localhost:10002
    - watch_in:
      - service: nginx

pad.freifunk-kassel.de:
  nginx_site.reverse_proxy_le:
    - target: http://localhost:10002
    - watch_in:
      - service: nginx

ffks-pad:
  user.present:
    - shell: /usr/sbin/nologin
    - order: 11
  postgres_user.present: []
  postgres_database.present:
    - owner: ffks-pad
    - owner_recurse: True

etherpad-lite-pkgs:
  pkg.installed:
    - pkgs:
      # Some of these are already in common.tools, but it doesn't hurt
      # listing everything from the official installation instructions list
      - gzip
      - git
      - curl
      - python
      - libssl-dev
      - pkg-config
      - build-essential
  npm.installed:
    - pkgs:
      - pgpass
    - require:
      - pkg: nodejs

https://github.com/ether/etherpad-lite.git:
  git.latest:
    - target: /home/ffks-pad/etherpad-lite
    - user: ffks-pad

/home/ffks-pad/etherpad-lite/settings.json:
  file.managed:
    - source: salt://nginx/configs/ffks-pad.settings.json
    - user: ffks-pad
    - groups: www-data
    - mode: 644
    - require:
      - git: https://github.com/ether/etherpad-lite.git

/etc/systemd/system/ffks-pad.service:
  file.managed:
    - source: salt://nginx/configs/ffks-pad.service
    - user: root
    - group: root
    - mode: 644
  service.running:
    - name: ffks-pad
    - enable: True
    - watch:
      - pkg: etherpad-lite-pkgs
      - git: https://github.com/ether/etherpad-lite.git
      - file: /home/ffks-pad/etherpad-lite/settings.json
      - file: /etc/systemd/system/ffks-pad.service
