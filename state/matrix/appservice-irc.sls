include:
  - nodejs

matrix-appservice-irc:
  user.present:
    - shell: /usr/sbin/nologin
  npm.installed:
    - user: matrix-appservice-irc
    - dir: /home/matrix-appservice-irc/matrix-appservice-irc
    - require:
      - user: matrix-appservice-irc
      - pkg: nodejs
