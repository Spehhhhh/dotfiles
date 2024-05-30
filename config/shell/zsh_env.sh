#===============================================================================
# 👇 GPG Signing
#===============================================================================
# if [ -r ~/.zshrc ]; then echo 'export GPG_TTY=$(tty)' >> ~/.zshrc; \
#   else echo 'export GPG_TTY=$(tty)' >> ~/.zprofile; fi

#===============================================================================
# 👇 oh-my-zsh init
#===============================================================================
export ZSH="${HOME}/.oh-my-zsh"

#===============================================================================
# 👇 zsh Theme
#===============================================================================
if [[ -n $SSH_CONNECTION ]]; then
  eval "$(starship init zsh)"
else
  eval "$(starship init zsh)"
fi

#===============================================================================
# 👇 zsh-vi-mode https://github.com/jeffreytse/zsh-vi-mode/issues/24
#===============================================================================
# export ZVM_INIT_MODE=sourcing

#===============================================================================
# 👇 Standard plugins can be found in $ZSH/plugins/
# 👇 Custom plugins may be added to $ZSH_CUSTOM/plugins/
# x <file> extract <file>
# showfiles show hidefiles
#===============================================================================
export plugins=(
  asdf
  colored-man-pages
  extract
  systemadmin
  zbell
  autoupdate              # https://github.com/TamCore/autoupdate-oh-my-zsh-plugins
  git-open                # https://github.com/paulirish/git-open
  zsh-autosuggestions     # https://github.com/zsh-users/zsh-autosuggestions
  zsh-syntax-highlighting # https://github.com/zsh-users/zsh-syntax-highlighting
  # zsh-completions         # https://github.com/zsh-users/zsh-completions
  # zsh-vi-mode             # https://github.com/jeffreytse/zsh-vi-mode
  # magic-enter
  # macos
)

#===============================================================================
# 👇 Set
#===============================================================================
export LANG=en_US.UTF-8

#===============================================================================
# 👇 broot https://github.com/Canop/broot
#===============================================================================
source "${HOME}"/.config/broot/launcher/bash/br

#===============================================================================
# 👇 History
#===============================================================================
export HIST_STAMPS="yyyy-mm-dd"
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY # Write to the history file immediately, not when the shell exits.

#===============================================================================
# 👇 oh-my-zsh autoupdate-zsh-plugin
#===============================================================================
export UPDATE_ZSH_DAYS=7

#===============================================================================
# 👇 oh-my-zsh init
#===============================================================================
source "$ZSH"/oh-my-zsh.sh

#===============================================================================
# 👇 fzf-tab https://github.com/Aloxaf/fzf-tab/wiki/Configuration (fzf-tab needs to be loaded after compinit (oh-my-zsh.sh))
#===============================================================================
source "$ZSH_CUSTOM"/plugins/fzf-tab/fzf-tab.plugin.zsh
zstyle ':fzf-tab:complete:cd:*' fzf-preview "lsd --icon=always $realpath"
zstyle ':fzf-tab:*' fzf-pad 10

#===============================================================================
# 👇 custom binary
#===============================================================================
export PATH="${HOME}/dotfiles/bin:$PATH"

#===============================================================================
# 👇 custom keybindings
#===============================================================================
# 👇 fzf
case $SYSTEM_TYPE in
mac_arm64)
  source "$(brew --prefix fzf)/shell/completion.zsh"
  source "$(brew --prefix fzf)/shell/key-bindings.zsh"
  ;;
mac_x86_64)
  source "/opt/homebrew/opt/fzf/shell/completion.zsh"
  source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
  ;;
linux_x86_64)
  source "$(brew --prefix fzf)/shell/completion.zsh"
  source "$(brew --prefix fzf)/shell/key-bindings.zsh"
  ;;
esac
# 👇 Option-S (Control-S)
bindkey '^S' _sudo-command-line
# 👇 Option-X
bindkey '≈' _fzf-dirs-widget
# 👇 Option-Left
bindkey "^[[1;3C" forward-word
# 👇 Option-Right
bindkey "^[[1;3D" backward-word
# 👇 Control-L accept zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions#key-bindings
bindkey '^L' autosuggest-accept
# 👇 Control-G
bindkey '^g' _navi_widget

#===============================================================================
# 👇 forgit https://github.com/wfxr/forgit
#===============================================================================
[ -f "$HOMEBREW_PREFIX"/share/forgit/forgit.plugin.zsh ] && source "$HOMEBREW_PREFIX"/share/forgit/forgit.plugin.zsh

#===============================================================================
# 👇 fzf
#===============================================================================
export FZF_DEFAULT_OPTS="--height=100% --layout=reverse --info=inline --border --margin=1 --padding=1"
export FZF_DEFAULT_COMMAND="fd --ignore-file ~/.rgignore --hidden --follow --ignore-case ."

#===============================================================================
# 👇 fzf Control-T to fuzzily search for a file or directory in your home directory then insert its path at the cursor
#===============================================================================
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

#===============================================================================
# 👇 fzf Option-C 快速查找目录 fuzzily search for a directory in your home directory then cd into it
#===============================================================================
bindkey 'ç' fzf-cd-widget
export FZF_ALT_C_COMMAND="fd --ignore-file ~/.rgignore --hidden --follow --ignore-case --type d"

#===============================================================================
# 👇 Preferred editor for local and remote sessions
#===============================================================================
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

#===============================================================================
# 👇 iTerm2 https://iterm2.com/documentation-shell-integration.html
#===============================================================================
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#===============================================================================
# 👇 pipx
#===============================================================================
export PIPX_DEFAULT_PYTHON="$(brew --prefix python@3.12)/bin/python3.12"

#===============================================================================
# 👇 direnv
#===============================================================================
eval "$(direnv hook bash)"

#===============================================================================
# 👇 thefuck
#===============================================================================
eval "$(thefuck --alias)"

#===============================================================================
# 👇 GitHub Copilot CLl (ghcs, ghce)
#===============================================================================
eval "$(gh copilot alias -- zsh)"

#===============================================================================
# 👇 puppeteer
#===============================================================================
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=$(brew --prefix)/bin/chromium

#===============================================================================
# 👇 tumxp
#===============================================================================
export DISABLE_AUTO_TITLE='true'

#===============================================================================
# 👇 bat
#===============================================================================
export BAT_THEME="OneHalfDark"

#===============================================================================
# 👇 LLVM
#===============================================================================
export PATH="$(brew --prefix llvm)/bin:${PATH}"
export LDFLAGS="-L$(brew --prefix llvm)/lib"
export CPPFLAGS="-I$(brew --prefix llvm)/include"

#===============================================================================
# 👇 Mojo
#===============================================================================
export MODULAR_HOME="$HOME/.modular"
export PATH="$MODULAR_HOME/pkg/packages.modular.com_mojo/bin:$PATH"

#===============================================================================
# 👇 navi
#===============================================================================
eval "$(navi widget zsh)"

#===============================================================================
# 👇 zoxide
# z foo<tab> # shows the same completions as cd
# z foo<space><tab> # shows interactive completions via zoxide
#===============================================================================
eval "$(zoxide init zsh)"

#===============================================================================
# 👇 autodetect architecture (and set `brew` path) (and set `python` path)
#===============================================================================
case $SYSTEM_TYPE in
mac_arm64)
  # python
  alias 'cvenv'='$(brew --prefix python@3.12)/bin/python3.12 -m venv .venv && source .venv/bin/activate && python3 -m pip install --upgrade -r $HOME/.requirements.txt'
  alias 'svenv'='source .venv/bin/activate'
  alias 'cenv'='conda create --prefix ./.env && conda activate ./.env'
  alias 'senv'='conda activate ./.env'
  # python miniforge
  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  if ! __conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"; then
    eval "$__conda_setup"
  else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
      . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
      export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<
  # java
  export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
  ;;
mac_x86_64)
  # brew
  if [[ -f /usr/local/homebrew/bin/brew ]]; then
    eval "$(/usr/local/homebrew/bin/brew shellenv)" # homebrew intel shell env
  fi
  # python
  eval "$(pyenv init --path)" # pyenv intel shell env
  eval "$(pyenv init -)"      # pyenv intel shell env
  alias 'cvenv'='python3 -m venv .venv && source .venv/bin/activate && python3 -m pip install --upgrade -r $HOME/.requirements.txt'
  alias 'svenv'='source .venv/bin/activate'
  # python miniconda
  ;;
linux_x86_64)
  # python
  alias 'cvenv'='python3 -m venv .venv && source .venv/bin/activate && python3 -m pip install --upgrade -r $HOME/.requirements.txt'
  alias 'svenv'='source .venv/bin/activate'
  ;;
esac

#===============================================================================
# 👇 auto-activate virtualen
#===============================================================================
auto_activate_venv() {
  if [[ -d "./venv" ]]; then
    source "./venv/bin/activate"
  elif [[ -d "./.venv" ]]; then
    source "./.venv/bin/activate"
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd auto_activate_venv
