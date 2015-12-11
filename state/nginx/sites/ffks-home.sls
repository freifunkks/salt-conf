include:
  - nginx
  - uwsgi

{% for site in ['home.ffks', 'freifunk-kassel.de', 'home.' + grains.host + '.ffks.de'] %}
{{ site }}:
  nginx_site.present:
    - configfile: salt://nginx/configs/ffks-home.nginx-conf
    - watch_in:
      - service: nginx
{% endfor %}

www.freifunk-kassel.de:
  nginx_site.redirect:
    - target: https://freifunk-kassel.de
    - watch_in:
      - service: nginx

ffks-home:
  user.present:
    - shell: /usr/bin/nologin
    - order: 11

/home/ffks-home/wikicontent:
  file.directory:
    - user: ffks-home
    - group: ffks-home
    - mode: 755

{% for dir in ['data', 'underlay'] %}
/home/ffks-home/wikicontent/{{ dir }}/pages:
  file.directory:
    - makedirs: True
    - user: ffks-home
    - group: ffks-home
    - dir_mode: 755
    - file_mode: 644
    - recurse: [user, group, mode]
    - require:
      - file: /home/ffks-home/wikicontent
{% endfor %}

/home/ffks-home/wikiconfig.py:
  file.managed:
    - source: salt://nginx/configs/ffks-home.wikiconfig.py
    - user: ffks-home
    - group: ffks-home
    - mode: 644
    - watch_in:
      - uwsgi: service

/home/ffks-home/moin.wsgi:
  file.managed:
    - source: salt://nginx/configs/ffks-home.wsgi
    - user: ffks-home
    - group: ffks-home
    - mode: 644
    - watch_in:
      - service: uwsgi

dependencies:
  pkg.installed:
    - pkgs:
      - uwsgi-plugin-python
      - python-moinmoin

/etc/uwsgi/apps-available/ffks-home.ini:
  file.managed:
    - source: salt://nginx/configs/ffks-home.uwsgi-ini
    - mode: 644

/etc/uwsgi/apps-enabled/ffks-home.ini:
  file.symlink:
    - target: /etc/uwsgi/apps-available/ffks-home.ini
    - require:
      - file: /etc/uwsgi/apps-available/ffks-home.ini
      - pkg: dependencies
    - watch_in:
      - service: uwsgi

https://github.com/freifunkks/moinmoin-theme.git:
  git.latest:
    - target: /home/ffks-home/theme
    - user: ffks-home
    - watch_in:
      - service: uwsgi

https://github.com/freifunkks/moinmoin-plugins.git:
  git.latest:
    - target: /home/ffks-home/plugins
    - user: ffks-home
    - watch_in:
      - uwsgi: service
