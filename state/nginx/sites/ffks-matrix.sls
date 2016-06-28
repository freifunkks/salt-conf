include:
  - nginx

matrix.ffks.de:
  nginx_site.present_le:
    - configfile: salt://nginx/configs/empty.nginx-conf
    - server_names:
      - matrix.ffks.de
      - matrix.{{ grains.host }}.ffks.de
    - watch_in:
      - service: nginx
