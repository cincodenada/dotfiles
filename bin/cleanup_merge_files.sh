#!/bin/bash
find -E . -regex ".*_(BACKUP|BASE|LOCAL|REMOTE)_.*" $@
