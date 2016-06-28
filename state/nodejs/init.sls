nodejs:
  pkgrepo.managed:
    - name: deb https://deb.nodesource.com/node_4.x jessie main
    - humanname: nodejs
    - dist: jessie
    - file: /etc/apt/sources.list.d/nodejs.list
    - key_url: https://deb.nodesource.com/gpgkey/nodesource.gpg.key
    - refresh_db: true
    - order: 2
  pkg.installed:
    - pkgs:
      - nodejs
      - npm
    - require:
      - pkgrepo: nodejs
