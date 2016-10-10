base:
  '*':
    - common.essentials
    - common.tools
    - common.users

  {% if pillar.minions[grains.id].gateway %}
    - common.gateway_pkgs
    - fastd
    - fastd.ffks_vpn
    - fastd.ffks_vpn.peerings
    - network.batman
  {% endif %}

  excalipurr.ffks:
    - grafana
    - graphite.api
    - graphite.carbon
    - matrix.appservice-irc
    - matrix.synapse
    - nginx
    - nginx.lets_encrypt
    - nginx.sites.ffks-dl
    - nginx.sites.ffks-gh
    - nginx.sites.ffks-home
    - nginx.sites.ffks-map
    - nginx.sites.ffks-matrix
    - nginx.sites.ffks-pad
    - nginx.sites.ffks-quassel
    - nginx.sites.ffks-stats
    - nginx.sites.flipdot-stats
    - postgresql
    - quassel
    - sopel
    - uwsgi

  hammibal.ffks:
    - buildsrv
