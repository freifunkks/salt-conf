include:
  - nginx

stats.ffks:
  nginx_site.reverse_proxy:
    - target: http://localhost:10001
    - watch_in:
      - service: nginx

{% for site in ['stats.freifunk-kassel.de', 'stats.' + grains.host + '.ffks.de'] %}
{{ site }}:
  nginx_site.reverse_proxy_le:
    - target: http://localhost:10001
    - watch_in:
      - service: nginx
{% endfor %}
