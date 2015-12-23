base:
  '*':
    - common.essentials
    - common.network
    - common.tools
    - common.users
    - fastd

  'I@minion.gateway:True':
    - common.gateway-pkgs

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
