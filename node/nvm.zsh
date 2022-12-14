autoload -U add-zsh-hook
load-nvmrc() {
  # Exit if we haven't loaded nvmrc yet
  # Lazy aliases handle initial load, we just need to keep it up to date
  which nvm_find_nvmrc > /dev/null || return

  # Exit early if we're being called from completion, we're not useful there
  # and it slows things down. Adapted from:
  # https://unix.stackexchange.com/a/453170/48037
  emulate -L zsh  # because we may be sourced by zsh `emulate bash -c`
  local file="${funcfiletrace[1]%:*}"
  [[ "$file" == *"_cd" ]] && return

  local nvmrc_path="$(nvm_find_nvmrc)"
  local node_version=${${NVM_BIN##*node\/}%\/bin}
  if [ -z "$node_version" ]; then
    node_version = $(nvm version)
  fi

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
  
    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install $nvmrc_node_version
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use $nvmrc_node_version
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
