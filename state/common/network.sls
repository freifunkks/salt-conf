{% for iface, conf in pillar.get('minion:network-interfaces', {}).items() %}
{{ iface }}:
  network.managed: {{ conf }}
{% endfor %}
