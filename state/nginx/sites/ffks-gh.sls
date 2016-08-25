include:
  - nginx

gh.ffks.de:
  nginx_site.reverse_proxy_le:
    - target: http://localhost:3333
    - watch_in:
      - service: nginx
