include:
  - nginx

{% for site in ['api.ffks', 'api.freifunk-kassel.de', 'api.' + grains.host + '.ffks.de'] %}
{{ site }}:
  nginx_site.present:
    - configfile: salt://nginx/configs/ffks-api.nginx-conf
    - watch_in:
      - service: nginx
{% endfor %}

ffks-api:
  user.present:
    - createhome: False
    - shell: /usr/sbin/nologin
    - order: 11

/srv/http/ffks-api:
  file.directory:
    - user: ffks-api
    - group: www-data
    - dir_mode: 775
    - file_mode: 664
    - recurse: [user, group, mode]
    - require:
      - file: /srv/http

/srv/http/ffks-api/.bgcolor-fix.html:
  file.managed:
    - source: salt://nginx/configs/ffks-api.bgcolor-fix.html
    - user: ffks-api
    - group: www-data
    - mode: 664
    - require:
      - file: /srv/http/ffks-api
