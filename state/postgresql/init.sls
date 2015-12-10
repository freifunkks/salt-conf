postgresql:
  pkg.installed: []
  service.running:
    - enable: True
    - watch:
      - pkg: postgresql
