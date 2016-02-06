include:
  - fastd.fastd_vpn.gw-peerings.gateways
  - fastd.fastd_vpn.gw-peerings.nodes

#update-fastd-keys:
#  schedule.present:
#    - function: state.sls
#    - args:
#      - fastd.gw-peerings.nodes
#    - minutes: 5

salt-call state.sls fastd.fastd_vpn.gw-peerings.nodes:
  cron.present:
    - identifier: update-fastd-keys
    - minute: '*/5'
