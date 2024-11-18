export PATH="./bin:/usr/local/bin:/usr/local/sbin:$DOTFILES/bin:$HOME/bin:$HOME/bin/*:$HOME/.local/bin:$HOME/.nix-profile/bin:$HOME/.cargo/bin:$PATH"
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Load /etc/profile to pick up profile.d, ugh???
emulate sh -c 'source /etc/profile'
