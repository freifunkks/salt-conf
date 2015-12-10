include:
  - nginx

{% for site in ['stats.ffks', 'stats.freifunk-kassel.de', 'stats.' + grains.host + '.ffks.de'] %}
{{ site }}:
  nginx_site.reverse_proxy:
    - target: http://localhost:10001
    - watch_in:
      - service: nginx
{% endfor %}

ffks-stats:
  user.present:
    - shell: /usr/bin/nologin
    - order: 11
