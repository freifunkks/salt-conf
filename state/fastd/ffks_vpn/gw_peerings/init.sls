include:
  - fastd.ffks_vpn.gw_peerings.gateways
  - fastd.ffks_vpn.gw_peerings.nodes

salt-call state.sls fastd.ffks_vpn.gw_peerings.nodes:
  cron.present:
    - identifier: update-fastd-keys
    - minute: '*/5'
