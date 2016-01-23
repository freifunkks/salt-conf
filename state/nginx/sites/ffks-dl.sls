include:
  - nginx

dl.ffks:
  nginx_site.present:
    - configfile: salt://nginx/configs/ffks-dl.nginx-conf
    - watch_in:
      - service: nginx

dl.freifunk-kassel.de:
  nginx_site.present_le:
    - configfile: salt://nginx/configs/ffks-dl.nginx-conf
    - server_names:
      - dl.freifunk-kassel.de
      - dl.{{ grains.host }}.ffks.de
    - watch_in:
      - service: nginx

ffks-dl:
  user.present:
    - createhome: False
    - shell: /usr/sbin/nologin
    - order: 11

/srv/http/ffks-dl:
  file.directory:
    - user: ffks-dl
    - group: ffks-dl
    - dir_mode: 755
    - file_mode: 644
    - recurse: [user, group, mode]
    - require:
      - file: /srv/http

/srv/http/ffks-dl/.bgcolor-fix.html:
  file.managed:
    - source: salt://nginx/configs/ffks-dl.bgcolor-fix.html
    - user: ffks-dl
    - group: ffks-dl
    - mode: 644
    - require:
      - file: /srv/http/ffks-dl
