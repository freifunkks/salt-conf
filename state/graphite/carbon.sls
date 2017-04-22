graphite-carbon:
  pkg.installed: []
  user.present:
    - shell: /usr/sbin/nologin

/etc/carbon/carbon.conf:
  file.managed:
    - source: salt://graphite/carbon.conf
    - create: False
    - require:
      - pkg: graphite-carbon

/etc/carbon/storage-schemas.conf:
  file.managed:
    - source: salt://graphite/storage-schemas.conf
    - create: False
    - require:
      - pkg: graphite-carbon

/var/lib/graphite/:
  file.directory:
    - user: graphite-carbon
    - group: graphite-carbon
    - mode: 755
    - require:
      - pkg: graphite-carbon

carbon-cache:
  service.running:
    - enable: True
    - watch:
      - pkg: graphite-carbon
      - file: /etc/carbon/carbon.conf
      - file: /etc/carbon/storage-schemas.conf

/home/graphite-carbon/fd-spacestats.py:
  file.managed:
    - source: salt://graphite/fd-spacestats.py
    - user: graphite-carbon
    - group: graphite-carbon
    - mode: 700
  cron.present:
    - identifier: update-fd-space-statistics
    - user: graphite-carbon
    # frequency defaults to every minute

/home/graphite-carbon/fd-forumstats.py:
  file.managed:
    - source: salt://graphite/fd-forumstats.py
    - user: graphite-carbon
    - group: graphite-carbon
    - mode: 700
    - template: jinja
  cron.present:
    - identifier: update-fd-forum-statistics
    - user: graphite-carbon
    # frequency defaults to every minute
