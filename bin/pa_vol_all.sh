#!/bin/bash
# Get volume from http://unix.stackexchange.com/a/230533/48037
if [ "$1" == "mute" ]; then
    CMD="set-sink-mute"
    shift
else
    CMD="set-sink-volume"
fi
DEFAULTSINKNAME=`pactl info | awk -F": " '/Default Sink/ { print $2 }'`
DEFAULTSINKNUM=$((`pactl list sinks | grep Name | grep -n $DEFAULTSINKNAME | cut -d: -f1` - 1))

SINKNUM=`pactl list sinks short | grep RUNNING | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,'`
if [ -z "$SINKNUM" ]; then
    SINKNUM="$DEFAULTSINKNUM"
fi
for CURSINK in $SINKNUM; do
    pactl $CMD $CURSINK $@
done

# Pick a sink to indicate
CURMUTE=`pactl list sinks | grep '^[[:space:]]Mute:' | \
    head -n $(( $CURSINK + 1 )) | tail -n 1 | grep no`

echo "<$CURMUTE>"
if [ $CMD == "set-sink-mute" ] && [ -z "$CURMUTE" ]; then
    CURVOL='-m'
else
    CURVOL=`pactl list sinks | grep '^[[:space:]]Volume:' | \
        head -n $(( $CURSINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,'`
fi

# Volnoti can't show volumes > 100
# TOOD: Some way of inidicating over-volume?
if [ $CURVOL -gt 100 ]; then
    CURVOL=100
fi
volnoti-show $CURVOL
