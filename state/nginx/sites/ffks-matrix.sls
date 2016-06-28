include:
  - nginx

matrix.ffks.de:
  nginx_site.reverse_proxy_le:
    - target: http://localhost:8008
    - server_names:
      - matrix.ffks.de
      - matrix.{{ grains.host }}.ffks.de
    - watch_in:
      - service: nginx
