# Only set this if we haven't set $EDITOR up somewhere else previously.
if [[ "$EDITOR" == "" ]] ; then
  # Use (n)vim for my editor.
  if which nvim > /dev/null; then
    export EDITOR='nvim'
  else
    export EDITOR='vim'
  fi
fi
