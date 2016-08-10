include:
  - nginx

stats.fd:
  nginx_site.reverse_proxy:
    - target: http://localhost:10011
    - watch_in:
      - service: nginx

stats.flipdot.org:
  nginx_site.reverse_proxy_le:
    - target: http://localhost:10011
    - server_names:
      - stats.flipdot.org
    - watch_in:
      - service: nginx
