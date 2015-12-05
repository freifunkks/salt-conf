include:
  - nginx

stats.ffks:
  nginx_site.reverse_proxy:
    - target: http://localhost:10001

stats.freifunk-kassel.de:
  nginx_site.reverse_proxy:
    - target: http://localhost:10001

ffks-stats:
  user.present:
    - createhome: False
    - shell: /usr/bin/nologin

extend:
  nginx:
    service:
      - watch:
        - nginx_site: stats.ffks
        - nginx_site: stats.freifunk-kassel.de
