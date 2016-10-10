base:
  '*':
    - batman
    - fastd
    - minions
    - users

  {% if pillar.minions[grains.id].gateway %}
    - dhcp
  {% endif %}

  excalipurr.ffks:
    - discourse
    - grafana
    - sopel
