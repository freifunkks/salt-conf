include:
  - nginx
  - postgres

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

/var/www/pad.ffks:
  file.directory:
    - user: ffks-pad
    - group: www-data
    - dir_mode: 755
    - file_mode: 644
    - recurse: [user, group, mode]

dependencies:
  pkg.installed:
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
    - requires:
      - git: https://github.com/ether/etherpad-lite.git
