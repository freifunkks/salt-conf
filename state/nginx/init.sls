nginx:
  pkg.installed: []
  service.running:
    - watch:
      - pkg: nginx
      - file: /etc/nginx/nginx.conf # conf.d/*, sites-enabled/* ?

/etc/nginx/conf.d/ssl.conf:
  file.managed:
    - source: salt://nginx/ssl.conf
    - user: root
    - group: root
    - mode: 644
