essential_pkgs:
  pkg.installed:
    - pkgs:
      - git
      - ssh
      - sudo
      - zsh
    - order: 1

admin:
  group.present:
    - system: True
    - order: 1

ssh:
  service.running:
    - enable: True
    - order: 2
