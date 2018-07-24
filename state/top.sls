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
