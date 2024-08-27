#!/bin/bash
if [ -z "$1" ]; then
  DAYS=3
else
  DAYS=$1
  shift
fi

bold=$(tput bold)
normal=$(tput bold)
find-excluding node_modules vivor-stack tailormed -name .git | while read d; do
  dir=${d%.git}
  repo=$(basename $dir)
  (cd $dir && [ -d .git ] && \
    git log \
      --since="$DAYS day" \
      --branches \
      --author=joel@vivor.com \
      --color=always \
      --format="%cd %s" \
      --date='format:Wk%W %d %b %a %H _repo_' \
      "$@" | sed "s/_repo_/$repo/")
done | sort -r | less -R
