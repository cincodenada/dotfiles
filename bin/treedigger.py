#!/bin/env python3
import sys
from sh import zypper, awk
import re

ind = "  "

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
    pkg=$2
  } else {
    pkg=$3
  }
  printf "\\n%s=", pkg
}
/provides/ && t==1 {
  printf "%s,", $2
}
/^-/ { t=1 }
"""

def striplines(lines):
  return [l.strip() for l in lines.strip().split("\n") if l]

def info(msg, indent):
  print(indent + msg, file=sys.stderr)

class RepoInfo:
  def __init__(self):
    self.depmap = {}
    self.depcache = {}
    self.prvcache = {}

  def get_pkgs(self, specs):
    return set([self.prvcache.get(s, f'MISSING:{s}') for s in specs])

  def get_deps(self, pkg):
    return self.depcache[pkg]

  def resolve_deps(self, pkg):
    if pkg not in self.depmap:
      self.depmap[pkg] = set()
      specs = self.get_deps(pkg)
      self.depmap[pkg] = [p for p in self.get_pkgs(specs) if p != pkg]
    return self.depmap[pkg]

  def print_tree(self, pkg, indent=""):
    print(f"{indent}{pkg}")
    for dep in self.resolve_deps(pkg):
      if re.match("MISSING", dep):
        print(f"{indent}{ind}{dep}")
      else:
        self.print_tree(dep, indent + ind)

class RepoFile(RepoInfo):
  def __init__(self, repofile):
    super().__init__()
    self.pkgMatch = re.compile(r"=Pkg: (\S+)")
    self.initState()
    self.read_repofile(repofile)

  def initState(self, pkg = None):
    self.pkg = pkg
    self.mode = None
    self.provides = []
    self.requires = []

  def add_pkg(self):
    self.depcache[self.pkg] = self.requires
    for p in self.provides:
      self.prvcache[p] = self.pkg
    
  def parse_line(self, line):
    pkgresult = self.pkgMatch.match(line)
    if pkgresult:
      self.add_pkg()
      self.initState(pkgresult[1])
      return
    if line == "+Prv:":
      self.mode = "prv"
      return
    if line == "+Req:":
      self.mode = "req"
      return
    if line[0] in ['+', '-', '=']:
      self.mode = None
      return

    parts = line.split(" ")
    if parts[0].startswith("rpmlib("):
      return

    if self.mode == "prv":
      self.provides.append(parts[0])
    elif self.mode == "req":
      self.requires.append(parts[0])

  def read_repofile(self, repofile):
    for line in open(repofile, 'r'):
      self.parse_line(line.strip())

class ZypperCli(RepoInfo):
  def get_pkgs(self, specs):
    todo = [s for s in specs if s not in self.prvcache]
    if len(todo):
      provspecs = striplines(awk(
        parse_provides,
        _in=zypper("-t", "search", "--provides", "--match-exact", "-i", "-v", *todo)
      ))
      print(provspecs)
      for spec in provspecs:
        (pkg, provlist) = spec.split("=", 1)
        for prov in provlist.split(","):
          self.prvcache[prov] = pkg
    return set([self.prvcache[s] for s in specs])

  def get_deps(self, pkg, indent=""):
    if pkg not in self.depcache:
      nextindent=indent + " "
      info(f"Fetching deps for {pkg}", indent)
      reqs = striplines(awk(parse_reqs, _in=zypper("-t", "info", "--requires", pkg)))
      info(f"Fetching packages for deps: {','.join(reqs)}", indent)
    return self.depcache[pkg]

RepoFile('/tmp/systemrepo.txt').print_tree(sys.argv[1])
