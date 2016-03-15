quassel-core:
  pkg.installed

quasselcore:
  service.running:
    - enable: True
    - require:
      - pkg: quassel-core
