/home/aliases.json:
  file.managed:
    - contents: |
        {{ pillar['aliases'] | json | indent(8) }}
