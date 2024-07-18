#!/bin/env python3
import sys
from sh import zypper, awk

def info(msg, indent):
  print(indent + msg, file=sys.stderr)

def get_deps(pkg, indent=""):
  nextindent=indent + "  "
  info(f"Fetching deps for {pkg}", indent)
  print(f"{indent}{pkg}(")
  reqs = awk(
    'rq==1 && $1 { print $1 } /Requires/ { if($3 ~ /^\[/) { rq=1 } else if($3 ~ /^[^-]/) { print $3 } }',
    _in=zypper("info", "--requires", pkg)
  )
  info(f"Fetching packages for deps: {','.join(reqs)}", indent)
  nextpkgs=[]
  for spec in reqs:
    info(f"Fetching packages for {spec}...", nextindent)
    curpkgs=awk(
      '/package/ && t==1 { if($1 == "|") { print $2 } else { print $3 } } /^-/ { t=1 }',
      _in=zypper("wp", spec)
    )
    info(f"Adding to queue: {curpkgs}", nextindent)
    nextpkgs+=curpkgs

  for pkg in nextpkgs:
    get_deps(pkg, nextindent)

get_deps(sys.argv[2])

