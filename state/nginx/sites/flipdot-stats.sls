include:
  - nginx

stats.ffks:
  nginx_site.reverse_proxy:
    - target: http://localhost:10011
    - watch_in:
      - service: nginx

stats.freifunk-kassel.de:
  nginx_site.reverse_proxy_le:
    - target: http://localhost:10011
    - server_names:
      - stats.flipdot.org
    - watch_in:
      - service: nginx
