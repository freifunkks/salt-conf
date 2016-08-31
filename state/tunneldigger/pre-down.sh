#!/bin/bash
INTERFACE="$3"
MTU="$4"

# Remove the interface from our bridge
brctl delif digger${MTU} $INTERFACE
