matrix:
  pkgrepo.managed:
    - name: deb http://matrix.org/packages/debian/ jessie main
    - humanname: matrix
    - dist: jessie
    - file: /etc/apt/sources.list.d/matrix.list
    - key_url: https://matrix.org/packages/debian/repo-key.asc
    - refresh_db: true
    - order: 2

matrix-synapse:
  pkg.installed:
    - order: 3
  service.running:
    - enable: true
    - reload: true

/etc/matrix-synapse/conf.d/matrix.ffks.de.yaml:
  file.managed:
    - source: salt://matrix/matrix.ffks.de.yaml
    - require:
      - pkg: matrix-synapse
    - watch_in:
      - service: matrix-synapse
