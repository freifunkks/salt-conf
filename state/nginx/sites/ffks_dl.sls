include:
  - nginx

dl.ffks:
  nginx_site.present:
    - configfile: salt://nginx/configs/dl.ffks.nginx-conf
    - watch_in:
      - service: nginx

dl.freifunk-kassel.de:
  nginx_site.present:
    - configfile: salt://nginx/configs/dl.ffks.nginx-conf
    - watch_in:
      - service: nginx

ffks-dl:
  user.present:
    - createhome: False
    - shell: /usr/bin/nologin

/srv/http/dl.ffks:
  file.directory:
    - user: ffks-dl
    - group: www-data
    - dir_mode: 775
    - file_mode: 664
    - recurse: [user, group, mode]
    - require:
      - file: /srv/http

/srv/http/dl.ffks/.bgcolor-fix.html:
  file.managed:
    - source: salt://nginx/configs/dl.ffks.bgcolor-fix.html
    - user: ffks-dl
    - group: www-data
    - mode: 664
    - require:
      - file: /srv/http/dl.ffks
