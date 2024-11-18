#!/usr/bin/awk -f
{
  patsplit($0, specs, "([^ ]+:[A-Za-z0-9]+) \\([^)]+\\)")
  for(i in specs) {
    split(specs[i], parts, "[: (),]+")
    for(p in parts) {
      printf "%s arch=%s from=%s to=%s\n", parts[1], parts[2], parts[3], parts[4]
    }
  }
}
/Install/ {
}
