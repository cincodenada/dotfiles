#!/bin/bash -x
SINK=$(pactl load-module module-null-sink sink_name=Combined)
LB1=$(pactl load-module module-loopback sink=Combined)
LB2=$(pactl load-module module-loopback sink=Combined)

function unload {
  pactl unload-module $SINK
  pactl unload-module $LB1
  pactl unload-module $LB2
}

trap unload EXIT

sleep infinity
