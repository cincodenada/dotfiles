bindkey -v
export KEYTIMEOUT=1 # Speed up mode switching

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^R' history-incremental-search-backward

# backspace and ^h working even after
# returning from command mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char

bindkey '^P' up-history
bindkey '^N' down-history

[[ -z "$terminfo[kdch1]" ]] || bindkey "$terminfo[kdch1]" delete-char
[[ -z "$terminfo[khome]" ]] || bindkey "$terminfo[khome]" beginning-of-line
[[ -z "$terminfo[kend]" ]] || bindkey "$terminfo[kend]" end-of-line
[[ -z "$terminfo[kich1]" ]] || bindkey "$terminfo[kich1]" overwrite-mode
[[ -z "$terminfo[knp]" ]] || bindkey "$terminfo[knp]" down-history
[[ -z "$terminfo[kpp]" ]] || bindkey "$terminfo[kpp]" up-history
