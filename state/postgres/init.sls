postgres:
  pkg.installed:
    - name: postgres-9.4
  service.running:
    - watch:
      - pkg: postgres
