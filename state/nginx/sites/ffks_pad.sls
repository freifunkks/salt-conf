include:
  - nginx

pad.ffks:
  nginx_site.reverse_proxy:
    - target: http://localhost:10002

pad.freifunk-kassel.de:
  nginx_site.reverse_proxy:
    - target: http://localhost:10002

ffks-pad:
  user.present:
    - createhome: False
    - shell: /usr/bin/nologin

extend:
  nginx:
    service:
      - watch:
        - nginx_site: pad.ffks
        - nginx_site: pad.freifunk-kassel.de
