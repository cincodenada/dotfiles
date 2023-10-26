#!/bin/bash
SYSPATH="/sys/class/backlight/intel_backlight"
MAXBRIGHT=$(cat $SYSPATH/max_brightness)

ADJ=${1%\%}
STEP=$(($MAXBRIGHT/(100/$ADJ)))

NEWBRIGHT=$(($(cat $SYSPATH/brightness) + $STEP))
echo $NEWBRIGHT > $SYSPATH/brightness

#volnoti-show $CURVOL
