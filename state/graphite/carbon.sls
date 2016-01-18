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
