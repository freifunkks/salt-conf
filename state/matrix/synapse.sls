matrix-synapse-pkgs:
  pkg.installed:
    - pkgs:
      - python2-psycopg

matrix-synapse:
  pkgrepo.managed:
    - name: deb http://matrix.org/packages/debian/ jessie main
    - humanname: matrix
    - dist: jessie
    - file: /etc/apt/sources.list.d/matrix.list
    - key_url: https://matrix.org/packages/debian/repo-key.asc
    - refresh_db: True
  pkg.installed:
    - require:
      - pkgrepo: matrix-synapse
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: matrix-synapse
      - pkg: matrix-synapse-pkgs
  postgres_user.present:
    - require:
      - pkg: matrix-synapse
  postgres_database.present:
    - owner: matrix-synapse
    - owner_recurse: True
    - require:
      - pkg: matrix-synapse

/etc/matrix-synapse/conf.d/matrix.ffks.de.yaml:
  file.managed:
    - source: salt://matrix/matrix.ffks.de.yaml
    - require:
      - pkg: matrix-synapse
    - watch_in:
      - service: matrix-synapse
