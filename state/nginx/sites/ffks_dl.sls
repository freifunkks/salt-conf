dl.ffks:
  nginx_site.present:
    - root: /srv/www/dl.ffks
    - conf: salt://nginx/sites/dl.ffks

dl.freifunk-kassel.de:
  nginx_site.present:
    - root: /srv/www/dl.ffks
    - conf: salt://nginx/sites/dl.ffks
