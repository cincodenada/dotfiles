[[ -z "$terminfo[kdch1]" ]] || bindkey "$terminfo[kdch1]" delete-char
[[ -z "$terminfo[khome]" ]] || bindkey "$terminfo[khome]" beginning-of-line
[[ -z "$terminfo[kend]" ]] || bindkey "$terminfo[kend]" end-of-line
[[ -z "$terminfo[kich1]" ]] || bindkey "$terminfo[kich1]" overwrite-mode

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
