# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
  alias ls="gls -F --color=auto"
  alias l="gls -lAh --color=auto"
  alias ll="gls -l --color=auto"
  alias la="gls -A --color=auto"
else
  alias ls="ls -F --color=auto"
  alias l="ls -lAh --color=auto"
  alias ll="ls -l --color=auto"
  alias la="ls -A --color=auto"
fi

alias unescape='perl -e "use URI::Escape; print uri_unescape(<>);"'
alias curscrot="ls --color=no -t1 ~/*scrot.png | head -n1"
