base:
  '*':
    - common.essentials
    - common.tools
    - common.users.flx
    - common.users.hanspolo
    - common.users.jplatte

  'I@gateway:True':
    - common.gateway-pkgs

  excalipurr.ffks:
    - nginx
    - nginx.sites.ffks-dl
    - nginx.sites.ffks-home
    - nginx.sites.ffks-map
    - nginx.sites.ffks-pad
    #- nginx.sites.ffks-stats
    - postgresql
    - uwsgi
