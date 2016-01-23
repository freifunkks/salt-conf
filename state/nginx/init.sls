nginx:
  pkg.installed:
    - order: 2
  service.running:
    - enable: True
    - reload: True
    - watch:
      - pkg: nginx

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

openssl dhparam -out /etc/nginx/dhparams.pem 2048:
  cmd.run:
    - unless: test -e /etc/nginx/dhparams.pem
    - watch_in:
      - service: nginx

{% for conf in ['error_pages.conf', 'security.conf'] %}
/etc/nginx/conf.d/{{ conf }}:
  file.managed:
    - source: salt://nginx/{{ conf }}
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: nginx
{% endfor %}

{% for error in ['403', '404', '500', '502', '503', '504'] %}
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
