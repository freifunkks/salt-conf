base:
  '*':
    - common.essentials
    - common.tools
    - common.users
    - fastd

  {% if pillar['minions'][grains['id']].gateway %}
    - common.gateway-pkgs
    - fastd.gw-peerings
    - network.batman
  {% endif %}

  excalipurr.ffks:
    - fastd.web-peerings
    - grafana
    - graphite.api
    - graphite.carbon
    - nginx
    - nginx.lets-encrypt
    - nginx.sites.ffks-dl
    - nginx.sites.ffks-home
    - nginx.sites.ffks-map
    - nginx.sites.ffks-pad
    - nginx.sites.ffks-stats
    - postgresql
    - uwsgi
