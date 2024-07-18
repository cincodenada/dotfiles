#!/bin/env python3
import sys
from sh import zypper, awk

parse_reqs = """
rq==1 && $1 { print $1 }
/Requires/ {
  if($3 ~ /^\[/) {
    rq=1
  } else if($3 ~ /^[^-\(]/) {
    print $3
  }
}
"""

parse_provides = """
/package/ && t==1 {
  if($1 == "|") {
    print $2
  } else {
    print $3
  }
}
/^-/ { t=1 }
"""

def striplines(lines):
  return [l.strip() for l in lines.strip().split("\n") if l]

def info(msg, indent):
  print(indent + msg, file=sys.stderr)

class DepTree:
  def __init__(self):
    self.depmap = {}
    self.pkgcache = {}

  def get_pkg(self, spec):
    if spec not in self.pkgcache:
      self.pkgcache[spec] = striplines(awk(parse_provides, _in=zypper("-t", "wp", spec)))
    return self.pkgcache[spec]

  def get_deps(self, pkg, indent=""):
    if pkg not in self.depmap:
      nextindent=indent + " "
      info(f"Fetching deps for {pkg}", indent)
      reqs = striplines(awk(parse_reqs, _in=zypper("-t", "info", "--requires", pkg)))
      info(f"Fetching packages for deps: {','.join(reqs)}", indent)
      self.depmap[pkg] = set()
      for spec in reqs:
        info(f"Fetching packages for {spec}...", nextindent)
        curpkgs = self.get_pkg(spec)
        info(f"Adding to queue: {curpkgs}", nextindent)
        self.depmap[pkg].update(curpkgs)

    return  self.depmap[pkg]

  def print_tree(self, pkg, indent=""):
    print(f"{indent}{pkg}")
    for dep in self.get_deps(pkg, indent):
      self.print_tree(dep, indent + " ")

DepTree().print_tree(sys.argv[1])
