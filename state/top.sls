base:
  '*':
    - common.essentials
    - common.network
    - common.tools
    - common.users
    - fastd

  {% if pillar['minions'][grains['id']].gateway %}
    - common.gateway-pkgs
  {% endif %}

  excalipurr.ffks:
    - grafana
    - nginx
    - nginx.sites.ffks-dl
    - nginx.sites.ffks-home
    - nginx.sites.ffks-map
    - nginx.sites.ffks-pad
    - nginx.sites.ffks-stats
    - postgresql
    - uwsgi
