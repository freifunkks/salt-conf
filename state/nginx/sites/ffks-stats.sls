include:
  - nginx

stats.ffks:
  nginx_site.reverse_proxy:
    - target: http://localhost:10001
    - watch_in:
      - service: nginx

stats.freifunk-kassel.de:
  nginx_site.reverse_proxy_le:
    - target: http://localhost:10001
    - watch_in:
      - service: nginx
