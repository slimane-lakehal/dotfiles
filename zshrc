# ─────────────────────────────────────────────────────────────
# Oh My Zsh
# ─────────────────────────────────────────────────────────────
ZSH=$HOME/.oh-my-zsh
ZSH_THEME=""  # Starship gère le prompt

ZSH_DISABLE_COMPFIX=true

plugins=(
  git
  gitfast
  common-aliases
  zsh-syntax-highlighting
  zsh-autosuggestions
  history-substring-search
  ssh-agent
)

source "${ZSH}/oh-my-zsh.sh"

unalias rm 2>/dev/null  # common-aliases ajoute un rm interactif, on ne veut pas ça
unalias lt 2>/dev/null

# ─────────────────────────────────────────────────────────────
# PATH
# ─────────────────────────────────────────────────────────────
export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

# ─────────────────────────────────────────────────────────────
# Locale
# ─────────────────────────────────────────────────────────────
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ─────────────────────────────────────────────────────────────
# Editor
# ─────────────────────────────────────────────────────────────
export EDITOR=code

# ─────────────────────────────────────────────────────────────
# Python (pyenv)
# ─────────────────────────────────────────────────────────────
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYTHONBREAKPOINT=ipdb.set_trace
type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init - 2>/dev/null)"

# ─────────────────────────────────────────────────────────────
# Node (nvm)
# ─────────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Auto-switch node version quand un .nvmrc est trouvé
autoload -U add-zsh-hook
load-nvmrc() {
  if nvm -v &>/dev/null; then
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use --silent
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      nvm use default --silent
    fi
  fi
}
type -a nvm > /dev/null && add-zsh-hook chpwd load-nvmrc
type -a nvm > /dev/null && load-nvmrc

# ─────────────────────────────────────────────────────────────
# Aliases
# ─────────────────────────────────────────────────────────────
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# ─────────────────────────────────────────────────────────────
# Starship prompt
# ─────────────────────────────────────────────────────────────
type -a starship > /dev/null && eval "$(starship init zsh)"
# Added by dbt Fusion extension (ensure dbt binary dir on PATH)
if [[ ":$PATH:" != *":/home/slim/.local/bin:"* ]]; then
  export PATH=/home/slim/.local/bin:"$PATH"
fi
# Added by dbt Fusion extension
alias dbtf=/home/slim/.local/bin/dbt

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform
