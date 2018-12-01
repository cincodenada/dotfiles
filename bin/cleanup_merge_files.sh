#!/bin/bash
find -regextype posix-extended -regex ".*_(BACKUP|BASE|LOCAL|REMOTE)_.*" $@
