nginx:
  pkg.installed: []
  service.running:
    - watch:
      - pkg: nginx

/etc/nginx/conf.d/ssl.conf:
  file.managed:
    - source: salt://nginx/ssl.conf
    - user: root
    - group: root
    - mode: 644
