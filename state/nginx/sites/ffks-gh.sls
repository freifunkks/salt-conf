include:
  - nginx

gh.ffks:
  nginx_site.reverse_proxy:
    - target: http://localhost:3333
    - watch_in:
      - service: nginx
