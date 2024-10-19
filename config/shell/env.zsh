#===============================================================================
# 👇 Proxy Configuration
#===============================================================================
set_proxy() {
  export https_proxy=http://127.0.0.1:6152
  export http_proxy=http://127.0.0.1:6152
  export all_proxy=socks5://127.0.0.1:6153
}

unset_proxy() {
  unset https_proxy http_proxy all_proxy
}

set_proxy

#===============================================================================
# 👇 GPG Signing
#===============================================================================
# if [ -r ~/.zshrc ]; then
#   echo "export GPG_TTY=$(tty)" >>~/.zshrc
# else
#   echo "export GPG_TTY=$(tty)" >>~/.zprofile
# fi

#===============================================================================
# 👇 zsh options https://stackoverflow.com/questions/30028730/how-to-prevent-execution-of-command-in-zsh
#===============================================================================
setopt NO_NOMATCH
setopt NO_NULL_GLOB

#===============================================================================
# 👇 interactive comments
#===============================================================================
setopt interactivecomments

#===============================================================================
# 👇 oh-my-zsh init
#===============================================================================
# export ZSH="${HOME}/.oh-my-zsh"

#===============================================================================
# 👇 Initialize zellij when running in Alacritty and not in Zed
#===============================================================================
export ZELLIJ_AUTO_ATTACH="false"
export ZELLIJ_AUTO_EXIT="true"

if [[ "$__CFBundleIdentifier" == "org.alacritty" && "$TERM_PROGRAM" != "zed" ]]; then
  if [[ -z "$ZELLIJ" ]]; then
    if [[ "$ZELLIJ_AUTO_ATTACH" == "true" ]]; then
      zellij attach -c default
    else
      zellij
    fi
    if [[ "$ZELLIJ_AUTO_EXIT" == "true" ]]; then
      exit
    fi
  fi
  if [[ "$ZELLIJ_PANE_ID" == "0" ]]; then
    fastfetch
  fi
fi

# zellij_pane_name_update() {
#   if [[ -n $ZELLIJ && -n $1 ]]; then
#     local cmd=$(echo "$1" | awk '{print $1}')
#     if [[ -n $cmd ]]; then
#       command nohup zellij action rename-pane "$cmd" >/dev/null 2>&1 || true
#     fi
#   fi
# }
# preexec_functions+=(zellij_pane_name_update)

zellij_tab_name_update() {
    if [[ -n $ZELLIJ ]]; then
        local current_dir=$PWD
        if [[ $current_dir == $HOME ]]; then
            current_dir="~"
        else
            current_dir=${current_dir##*/}
        fi
        command nohup zellij action rename-tab $current_dir >/dev/null 2>&1
    fi
}

zellij_tab_name_update
chpwd_functions+=(zellij_tab_name_update)

#===============================================================================
# 👇 zsh Theme
#===============================================================================
if [[ -n $SSH_CONNECTION ]]; then
  eval "$(starship init zsh)"
else
  eval "$(starship init zsh)"
fi

#===============================================================================
# 👇 Fix Case Sensitivity
#===============================================================================
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

#===============================================================================
# 👇 broot https://github.com/Canop/broot
#===============================================================================
source "${HOME}"/.config/broot/launcher/bash/br

#===============================================================================
# 👇 zsh-vi-mode https://github.com/jeffreytse/zsh-vi-mode/issues/24
#===============================================================================
# export ZVM_INIT_MODE=sourcing
# source "${ZSH_CUSTOM}"/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

#===============================================================================
# 👇 fzf init
#===============================================================================
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

export FZF_DEFAULT_OPTS="--height=100% --layout=reverse --info=inline --border --margin=1 --padding=1"
export FZF_DEFAULT_COMMAND="fd --ignore-file ~/.rgignore --hidden --follow --ignore-case ."

#===============================================================================
# 👇 Standard plugins can be found in $ZSH/plugins/
# 👇 Custom plugins may be added to $ZSH_CUSTOM/plugins/
#===============================================================================
source "$ZSH_CUSTOM"/plugins/git-open/git-open.plugin.zsh
source "$ZSH_CUSTOM"/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source "$ZSH_CUSTOM"/plugins/ugit/ugit.plugin.zsh

#===============================================================================
# 👇 fzf-tab https://github.com/Aloxaf/fzf-tab/wiki/Configuration (fzf-tab needs to be loaded after compinit (oh-my-zsh.sh))
#===============================================================================
source "$ZSH_CUSTOM"/plugins/fzf-tab/fzf-tab.plugin.zsh

#===============================================================================
# 👇 fzf-tab config
#===============================================================================
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons --all --oneline --ignore-glob=".DS_Store" $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-pad 10

#===============================================================================
# 👇 custom keybindings
#===============================================================================
# 👇 Option-S (Control-S)
# bindkey '^S' _sudo-command-line
# 👇 Option-Left
bindkey "^[[1;3C" forward-word
# 👇 Option-Right
bindkey "^[[1;3D" backward-word
# 👇 Control-L accept zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions#key-bindings (Using Control-F Instead)
# bindkey '^L' autosuggest-accept

#===============================================================================
# 👇 forgit https://github.com/wfxr/forgit
#===============================================================================
[ -f "$HOMEBREW_PREFIX"/share/forgit/forgit.plugin.zsh ] && source "$HOMEBREW_PREFIX"/share/forgit/forgit.plugin.zsh

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
if [[ -n $SSH_CONNECTION || -n $ZELLIJ ]]; then
  export EDITOR='nvim'
  export VISUAL='nvim'
else
  export EDITOR='zed --wait'
  export VISUAL='zed --wait'
fi

#===============================================================================
# 👇 OrbStack
#===============================================================================
source "$HOME"/.orbstack/shell/init.zsh 2>/dev/null || :

#===============================================================================
# 👇 GitHub Copilot CLl (ghcs, ghce)
#===============================================================================
eval "$(gh copilot alias -- zsh)"

#===============================================================================
# 👇 tumxp
#===============================================================================
export DISABLE_AUTO_TITLE='true'

#===============================================================================
# 👇 bat
#===============================================================================
export BAT_THEME="OneHalfDark"

#===============================================================================
# 👇 atuin
#===============================================================================
eval "$(atuin init zsh)"

#===============================================================================
# 👇 zoxide
# z foo<tab> # shows the same completions as cd
# z foo<space><tab> # shows interactive completions via zoxide
#===============================================================================
eval "$(zoxide init zsh)"

#===============================================================================
# 👇 mise
#===============================================================================
eval "$(mise activate zsh)"

#===============================================================================
# 👇 LM Studio CLI tool
#===============================================================================
export PATH="$PATH:/Users/alex/.cache/lm-studio/bin"

#===============================================================================
# 👇 autodetect architecture (and set `brew` path) (and set `python` path)
#===============================================================================
case $SYSTEM_TYPE in
mac_arm64)
  # python miniforge
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
  ;;
mac_x86_64)
  # brew
  if [[ -f /usr/local/homebrew/bin/brew ]]; then
    eval "$(/usr/local/homebrew/bin/brew shellenv)"
  fi
  # python
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  ;;
linux_x86_64)
  # python
  ;;
esac
