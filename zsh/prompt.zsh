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

DIRECTORY_NAME="%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"


itime() {
  date=""
  if [ -n "$1" ]; then
    if [[ *" "* == $1 ]]; then
      date="-f '%F %T' $1"
    elif [[ *":" == $1 ]]; then
      date="-f '%T' $1"
    else
      date=$1
    fi
  fi
  date -j -u -v+1H $date | awk -F'[ :]' '{printf "@%03.0f", ($6+$5*60+$4*3600)/86.4}'
}

shlvl() {
  IGNORE=1
  if [ -n "$TMUX" ]; then
    IGNORE=2
  fi

  EFFECTIVE=$(($SHLVL-$IGNORE))
  if [ $EFFECTIVE -gt 0 ]; then
    printf "|%.s" {1..$EFFECTIVE}
  fi
}

# Check untracked files
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep -q '^?? ' 2> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[staged]+='T'
    fi
}

# Check vs remote
zstyle ':vcs_info:git*+set-message:*' hooks git-st
function +vi-git-st() {
    local ahead behind
    local -a gitstatus

    # Exit early in case the worktree is on a detached HEAD
    git rev-parse ${hook_com[branch]}@{upstream} >/dev/null 2>&1 || return 0

    local -a ahead_and_behind=(
        $(git rev-list --left-right --count HEAD...${hook_com[branch]}@{upstream} 2>/dev/null)
    )

    ahead=${ahead_and_behind[1]}
    behind=${ahead_and_behind[2]}

    (( $ahead )) && gitstatus+=( "+${ahead}" )
    (( $behind )) && gitstatus+=( "-${behind}" )

    hook_com[misc]+=${(j:/:)gitstatus}
}

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr 1
zstyle ':vcs_info:git:*' stagedstr 1

BRANCH_COLOR='%1(c.'$fg_bold[blue]'.%1(u.'$fg_bold[red]'.'$fg_bold[green]'))'
# If there are staged and unstaged changes, add an asterisk so we can distinguish between that and only staged
BRANCH_SUFFIX='%1(u.%1(c.*.).)'
BASE_FORMAT="on %{$BRANCH_COLOR%}%b$BRANCH_SUFFIX%{$reset_color%} $fg_bold[yellow]%m$reset_color"
EXIT_CODE="%(?..%1(?.%{$fg_bold[yellow]%}.%{$fg_bold[red]%}){%?}%{$reset_color%})"
zstyle ':vcs_info:git:*' actionformats "$BASE_FORMAT (%a)"
zstyle ':vcs_info:git:*' formats "$BASE_FORMAT"
export PROMPT=$'\n%{$fg_bold[blue]%}$(itime)%{$reset_color%} $DIRECTORY_NAME ${vcs_info_msg_0_}\
%{$fg[yellow]%}$(shlvl)%{$reset_color%}› '

# Keep prompt noise out of set -x for other things
get_x() {
  if [ -z "$ZSH_PROMPT_DEBUG" ]; then
    echo +x
  else
    echo -x
  fi
}

precmd() {
  set $(get_x)
  vcs_info
  title "zsh" "%m" "%55<...<%~"
}

demo_prompt() {
  IS_DEMO="yes"
  RPS1=""
  export PROMPT=$'$DIRECTORY_NAME\010› '
  zle reset-prompt
}

function zle-line-init zle-keymap-select {
    [ -z "$IS_DEMO" ] || return

    NVM_VERSION=${${NVM_BIN#*node/}%/bin}
    if [ -z NVM_VERSION ]; then
      NVM_PROMPT=""
    else
      NVM_PROMPT="[npm $NVM_VERSION]"
    fi
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
    RPS1="$NVM_PROMPT${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$EXIT_CODE$EPS1"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
