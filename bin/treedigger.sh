#!/bin/bash -e

set -o pipefail

ROOT=$1
ZYPPER=zypper

SEEN=""

get_deps() {
  PACKAGE=$1
  INDENT=$2
  NEXTINDENT="$INDENT  "
  >&2 echo "${NEXTINDENT}Fetching deps for $PACKAGE"
  echo "${INDENT}$PACKAGE("
  reqs=$($ZYPPER info --requires $PACKAGE | awk 'rq==1 && $1 { print $1 } /Requires/ { if($3 ~ /^\[/) { rq=1 } else if($3 ~ /^[^-]/) { printf $3 } }')
  >&2 echo "${INDENT}Fetching packages for deps: $reqs"
  nextpkgs=()
  for spec in $reqs; do
    >&2 echo "${NEXTINDENT}Fetching packages for $spec..."
    curpkgs=($($ZYPPER wp "$spec" | awk '/package/ && t==1 { if($1 == "|") { print $2 } else { print $3 } } /^-/ { t=1 }'))
    >&2 echo "${NEXTINDENT}Adding to queue: $curpkgs"
    nextpkgs=("${nextpkgs[@]}" "${curpkgs[@]}")
  done
  for pkg in $nextpkgs; do
    get_deps $pkg "$NEXTINDENT"
  done
  echo ")"
}

get_deps $ROOT ""
