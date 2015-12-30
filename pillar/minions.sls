{% import_yaml 'minions.yml' as minions %}

minions: {{ minions }}

aliases:
  {% for host, data in minions.items() %}
  - node_id: {{ data.alias }} ({{ host }})
    hostname: {{ host }}
    network:
      mesh_interfaces: ['{{ data.mac }}']
  {% endfor %}
