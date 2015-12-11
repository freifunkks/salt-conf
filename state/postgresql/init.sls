postgresql:
  pkg.installed:
    - order: 2
  service.running:
    - enable: True
    - watch:
      - pkg: postgresql
