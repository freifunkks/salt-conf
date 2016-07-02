include:
  - nodejs

matrix-appservice-irc:
  user.present:
    - shell: /usr/sbin/nologin
  npm.installed:
    - user: matrix-appservice-irc
    - dir: /home/matrix-appservice-irc
    - require:
      - user: matrix-appservice-irc
      - pkg: nodejs

/etc/systemd/system/matrix-appservice-irc.service:
  file.managed:
    - source: salt://matrix/appservice-irc.service
    - user: root
    - group: root
    - mode: 644
  service.running:
    - name: matrix-appservice-irc
    - enable: True
    - watch:
      - npm: matrix-appservice-irc
