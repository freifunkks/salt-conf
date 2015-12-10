nginx:
  pkg.installed: []
  service.running:
    - enable: True
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

{% for conf in ['error_pages.conf', 'security.conf'] %}
/etc/nginx/conf.d/{{ conf }}:
  file.managed:
    - source: salt://nginx/{{ conf }}
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx
{% endfor %}

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
