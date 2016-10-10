include:
  - fastd.ffks_vpn.peerings.gateways
  - fastd.ffks_vpn.peerings.nodes

salt-call state.sls fastd.ffks_vpn.peerings.nodes:
  cron.present:
    - identifier: update-fastd-keys
    - minute: '*/5'
