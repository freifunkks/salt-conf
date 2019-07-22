include:
  apt.jessie-backports

https://github.com/freifunkks/mesh-announce.git:
  git.latest:
    - target: /opt/mesh-announce

python3.4-dev:
  pkg.installed:
    - order: 2
