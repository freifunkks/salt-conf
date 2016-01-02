schedule:
  update-fastd-keys:
    function: state.sls
    args:
      - fastd.gw-peerings
    minutes: 5
