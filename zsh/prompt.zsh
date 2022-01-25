autoload colors && colors
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_dirty() {
  branch_name=$(zstyle ':vcs_info:git*' formats "%b")
  if [[ "$branch_name" == "" ]]
  then
    echo ""
  else
    st=$(zstyle ':vcs_info:git*' formats "%u")
    if [[ "$st" == "" ]]
    then
    else
      echo "on %{$fg_bold[red]%}$branch_name%{$reset_color%}"
    fi
  fi
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%} "
  fi
}

directory_name(){
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr 1
zstyle ':vcs_info:git*' formats 'on %{%1(u.'$fg_bold[red]'.'$fg_bold[green]')%}%b%{'$reset_color'%}'
export PROMPT=$'\n$(directory_name) ${vcs_info_msg_0_}\n› '

set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}%{$reset_color%}"
}

precmd() {
  vcs_info
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}

function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
