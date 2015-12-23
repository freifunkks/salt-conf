include:
  - nginx
  - postgresql

{% for site in ['pad.ffks', 'pad.freifunk-kassel.de', 'pad.' + grains.host + '.ffks.de'] %}
{{ site }}:
  nginx_site.reverse_proxy:
    - target: http://localhost:10002
    - watch_in:
      - service: nginx
{% endfor %}

ffks-pad:
  user.present:
    - shell: /usr/bin/nologin
    - order: 11
  postgres_user.present:
    - watch_in:
      - service: postgresql
  postgres_database.present:
    - owner: ffks-pad
    - owner_recurse: True
    - watch_in:
      - service: postgresql

etherpad-lite-pkgs:
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
  npm.installed:
    - pkgs:
      - pgpass

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
      - file: /home/ffks-pad/etherpad-lite/settings.json
      - file: /etc/systemd/system/ffks-pad.service
