base:
  '*':
    - fastd
    - minions
    - userdata

  {% if pillar['minions'][grains['id']].gateway %}
    - gw-schedule
  {% endif %}

  excalipurr.ffks:
    - grafana
