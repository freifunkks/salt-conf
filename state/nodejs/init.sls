nodejs:
  pkgrepo.managed:
    - name: deb https://deb.nodesource.com/node_7.x jessie main
    - humanname: nodejs
    - dist: jessie
    - file: /etc/apt/sources.list.d/nodejs.list
    - key_url: https://deb.nodesource.com/gpgkey/nodesource.gpg.key
    - refresh_db: True
    - order: 2
  pkg.installed:
    - require:
      - pkgrepo: nodejs
