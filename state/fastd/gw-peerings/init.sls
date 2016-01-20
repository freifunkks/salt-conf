include:
  - fastd.gw-peerings.gateways
  - fastd.gw-peerings.nodes

update-fastd-keys:
  schedule.present:
    - function: state.sls
    - args:
      - fastd.gw-peerings.nodes
    - minutes: 5
