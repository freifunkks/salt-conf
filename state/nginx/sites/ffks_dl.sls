include:
  - nginx

dl.ffks:
  nginx_site.present:
    - conf: salt://nginx/configs/dl.ffks

dl.freifunk-kassel.de:
  nginx_site.present:
    - conf: salt://nginx/configs/dl.ffks

ffks-dl:
  user.present:
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

extend:
  nginx:
    service:
      - watch:
        - nginx_site: dl.ffks
        - nginx_site: dl.freifunk-kassel.de
