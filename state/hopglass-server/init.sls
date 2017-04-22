hopglass-server:
  user.present:
    - order: 11

https://github.com/hopglass/hopglass-server.git:
  git.latest:
    - rev: v0.1.3
    - target: /home/hopglass-server/hopglass-server
    - force_fetch: True
    - force_reset: True
    - user: hopglass-server
    - require:
      - pkg: nodejs
      - user: hopglass-server

/home/hopglass-server/hopglass-server:
  npm.bootstrap:
    - user: hopglass-server
    - require:
      - git: https://github.com/hopglass/hopglass-server.git
      - npm: grunt-cli

/etc/systemd/system/hopglass-server@.service:
  file.managed:
    - source: salt://hopglass-server/hopglass-server@.service

hopglass-server@default.service:
  service.running:
    - enable: True
    - watch:
       - git: https://github.com/hopglass/hopglass-server.git
    - require:
       - file: /etc/systemd/system/hopglass-server@.service

/home/hopglass-server/hopglass-server/default/config.json:
   file.managed:
    - makedirs: True
    - user: hopglass-server
    - group: hopglass-server
    - source: salt://hopglass-server/config.json
    - template: jinja
    - require:
       - user: hopglass-server
       - git: https://github.com/hopglass/hopglass-server.git
