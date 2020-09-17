export PATH="./bin:/usr/local/bin:/usr/local/sbin:$DOTFILES/bin:$HOME/.cargo/bin:$PATH"
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

# Load /etc/profile to pick up profile.d, ugh???
emulate sh -c 'source /etc/profile'
