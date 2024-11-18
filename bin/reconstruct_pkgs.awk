#!/usr/bin/awk -f
{
  delete specs
  delete pkg
  delete arch
  delete basepkg
  delete first
  delete second
  patsplit($0, specs, "([^ ]+:[A-Za-z0-9]+) \\([^)]+\\)")
  for(i in specs) {
    split(specs[i], parts, "[: (),]+")
    basepkg[i] = parts[1]
    arch[i] = parts[2]
    pkg[i] = parts[1]":"parts[2]
    first[i] = parts[3]
    second[i] = parts[4]
  }
}
/Install/ {
  for(i in pkg) {
    version[pkg[i]] = first[i]
    removed[pkg[i]] = 0
    if(second[i] == "automatic") {
      auto[pkg[i]] = 1
    } else if(second[i] != "") {
      printf "Unexpected install: %s\n", specs[i] >"/dev/stderr"
    }
  }
}
/Upgrade/ {
  for(i in pkg) {
    if(removed[pkg[i]]) {
      printf "Upgrading removed package: %s\n", specs[i] >"/dev/stderr"
    }
    version[pkg[i]] = second[i]
  }
}
/Remove/ {
  for(i in pkg) {
    removed[pkg[i]] = 1
  }
}

END {
  for(p in version) {
    if(removed[p]) {
      state="🗑"
    } else if(auto[p]) {
      state="🤖"
    } else {
      state="✅"
    }
    printf "%s%s@%s\n", state, p, version[p]
  }
}
