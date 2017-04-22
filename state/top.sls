base:
  '*':
    - common.essentials
    - common.tools
    - common.users
    - fastd
    - fastd.ffks_vpn
    - network.batman

  {% if pillar.minions[grains.id].gateway %}
    - common.gateway_pkgs
    - fastd.ffks_vpn.peerings
    - openvpn.airvpn
  {% endif %}

  excalipurr.ffks:
    - fastd.ffks_vpn.peerings.gateways
    - grafana
    - graphite.api
    - graphite.carbon
    - network.batman
    - nginx
    - nginx.lets_encrypt
    - nginx.sites.ffks-dl
    - nginx.sites.ffks-gh
    - nginx.sites.ffks-home
    - nginx.sites.ffks-map
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
