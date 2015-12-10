nginx:
  pkg.installed: []
  service.running:
    - enable: True
    - watch:
      - pkg: nginx

/etc/nginx/conf.d/ssl.conf:
  file.managed:
    - source: salt://nginx/ssl.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx

/etc/nginx/conf.d/error_pages.conf:
  file.managed:
    - source: salt://nginx/error_pages.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx

/srv/http:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/srv/http/error_pages:
  file.directory:
    - user: www-data
    - group: www-data
    - mode: 755

# TODO: Add other error pages
{% for error in ['404', '500'] %}
/srv/http/error_pages/{{ error }}.html:
  file.managed:
    - source: salt://nginx/error_pages/{{ error }}.html
    - user: www-data
    - group: www-data
    - mode: 644
    - template: jinja
    - require:
      - file: /srv/http/error_pages
{% endfor %}
