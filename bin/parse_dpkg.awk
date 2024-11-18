#!/usr/bin/awk -f
{
  if($1 == "ii") {
    state="✅"
  } else if($1 == "rc") {
    state="🗑"
  } else {
    state=$1
  }
  printf "%s%s@%s\n", state, $2, $3
}
