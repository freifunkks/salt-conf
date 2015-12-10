include:
  - nginx
  - postgresql

pad.ffks:
  nginx_site.reverse_proxy:
    - target: http://localhost:10002
    - watch_in:
      - service: nginx

pad.freifunk-kassel.de:
  nginx_site.reverse_proxy:
    - target: http://localhost:10002
    - watch_in:
      - service: nginx

ffks-pad:
  user.present:
    - createhome: False
    - shell: /usr/bin/nologin
  postgres_user:
    - require:
      - pkg: postgresql
    - watch_in:
      - service: postgresql
  postgres_database:
    - require:
      - pkg: postgresql
    - watch_in:
      - service: postgresql

/var/www/pad.ffks:
  file.directory:
    - user: ffks-pad
    - group: www-data
    - mode: 755

dependencies:
  pkg.installed:
    - pkgs:
      # Some of these are already in common.tools, but it doesn't hurt
      # listing everything the official installation instructions list
      - gzip
      - git
      - curl
      - python
      - libssl-dev
      - pkg-config
      - build-essential

https://github.com/ether/etherpad-lite.git:
  git.latest:
    - target: /var/www/pad.ffks
    - user: ffks-pad
    - require:
      - file: /var/www/pad.ffks

/var/www/pad.ffks/settings.json:
  file.managed:
    - source: salt://nginx/configs/pad.ffks.settings.json
    - user: ffks-pad
    - groups: www-data
    - mode: 644
    - require:
      - git: https://github.com/ether/etherpad-lite.git

/etc/systemd/system/pad.ffks.service:
  file.managed:
    - source: salt://nginx/configs/pad.ffks.service
    - user: root
    - group: root
    - mode: 644
  service.running:
    - name: pad.ffks
    - enable: True
    - watch:
      - file: /var/www/pad.ffks/settings.json
      - file: /etc/systemd/system/pad.ffks.service
