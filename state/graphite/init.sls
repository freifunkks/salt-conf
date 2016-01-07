graphite:
  pkg.installed:
    - pkgs:
      - graphite-carbon
      - graphite-web
  user.present:
    - shell: /usr/bin/nologin

/etc/carbon/carbon.conf:
  file.managed:
    - source: salt://graphite/carbon.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - create: False
    - require:
      - pkg: graphite

/etc/carbon/storage-schemas.conf:
  file.managed:
    - source: salt://graphite/storage-schemas.conf
    - user: root
    - group: root
    - mode: 644
    - create: False
    - require:
      - pkg: graphite

/var/lib/graphite/:
  file.directory:
    - user: graphite
    - group: graphite
    - dir_mode: 755
    - file_mode: 644
    - recurse: [user, group, mode]
    - require:
      - pkg: graphite

carbon-cache:
  service.running:
    - enable: True
    - watch:
      - pkg: graphite
      - file: /etc/carbon/carbon.conf
      - file: /etc/carbon/storage-schemas.conf
