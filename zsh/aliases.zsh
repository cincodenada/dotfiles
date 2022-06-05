alias reload!='. ~/.zshrc'
alias :e=vi
alias node="node --experimental-repl-await"
if [ "$(uname)" = "Darwin" ]; then
  alias date="date -j"
fi
