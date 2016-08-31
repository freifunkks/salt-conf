#!/bin/bash
INTERFACE="$3"
MTU="$4"

source "$(dirname $0)/bridge_functions.sh"

# Set the interface to UP state
ip link set dev $INTERFACE up mtu $MTU

# Add the interface to our bridge
ensure_bridge digger${MTU}
brctl addif digger${MTU} $INTERFACE
