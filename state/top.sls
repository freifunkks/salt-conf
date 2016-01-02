base:
  '*':
    - common.essentials
    - common.network
    - common.tools
    - common.users
    - fastd

  {% if pillar['minions'][grains['id']].gateway %}
    - common.gateway-pkgs
    - fastd.gw-peerings
  {% endif %}

  excalipurr.ffks:
    - fastd.web-peerings
    - grafana
    - nginx
    - nginx.sites.ffks-dl
    - nginx.sites.ffks-home
    - nginx.sites.ffks-map
    - nginx.sites.ffks-pad
    - nginx.sites.ffks-stats
    - postgresql
    - uwsgi
