include:
  - nginx

quassel.freifunk-kassel.de:
  nginx_site.present_le:
    - configfile: salt://nginx/configs/ffks-quassel.nginx-conf
    - watch_in:
      - service: nginx
