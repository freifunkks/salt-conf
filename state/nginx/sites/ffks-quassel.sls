include:
  - nginx

quassel.freifunk-kassel.de:
  nginx_site.present_le:
    - configfile: salt://nginx/configs/ffks-quassel.nginx-conf
    - server_names:
      - quassel.freifunk-kassel.de
      - quassel.{{ grains.host }}.ffks.de
    - watch_in:
      - service: nginx
