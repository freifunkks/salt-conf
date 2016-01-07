include:
  - nginx

{% for site in ['dl.ffks', 'dl.freifunk-kassel.de', 'dl.' + grains.host + '.ffks.de'] %}
{{ site }}:
  nginx_site.present:
    - configfile: salt://nginx/configs/ffks-dl.nginx-conf
    - watch_in:
      - service: nginx
{% endfor %}

ffks-dl:
  user.present:
    - createhome: False
    - shell: /usr/sbin/nologin
    - order: 11

/srv/http/ffks-dl:
  file.directory:
    - user: ffks-dl
    - group: www-data
    - dir_mode: 775
    - file_mode: 664
    - recurse: [user, group, mode]
    - require:
      - file: /srv/http

/srv/http/ffks-dl/.bgcolor-fix.html:
  file.managed:
    - source: salt://nginx/configs/ffks-dl.bgcolor-fix.html
    - user: ffks-dl
    - group: www-data
    - mode: 664
    - require:
      - file: /srv/http/ffks-dl
