#!/bin/bash
if [[ $(uname -s) == "Darwin" ]]; then
  args="-E ."
else
  args=". -regextype posix-extended"
fi
find $args -regex ".*_(BACKUP|BASE|LOCAL|REMOTE)_.*" $@
