essential_pkgs:
  pkg.installed:
    - pkgs:
      - git
      - sudo
      - zsh
    - order: 1

admin:
  group.present:
    - system: True
    - order: 1
