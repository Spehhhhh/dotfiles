# 👇 zsh Theme
eval "$(starship init zsh)"

# 👇 plugins
ZSH_PLUGINS_DIR="$HOME/dotfiles/config/shell/plugins"

# 👇 fzf
__TREE_IGNORE="-I '.git' -I '*.py[co]' -I '__pycache__' $__TREE_IGNORE"
__FD_COMMAND="-L -H --no-ignore-vcs ${__TREE_IGNORE//-I/-E} $__FD_COMMAND"

export FZF_DEFAULT_COMMAND="fd $__FD_COMMAND"
# export FZF_DEFAULT_OPTS=" \
# --style minimal \
# --reverse \
# --multi \
# --bind 'ctrl-y:accept' \
# --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
# --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
# --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
# --color=selected-bg:#45475a"
export FZF_DEFAULT_OPTS=" \
--style minimal \
--reverse \
--multi \
--bind 'ctrl-y:accept' \
--color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
--color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
--color=marker:#7287fd,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39 \
--color=selected-bg:#bcc0cc"

# 👇 fzf-tab
source "$ZSH_PLUGINS_DIR"/fzf-tab/fzf-tab.plugin.zsh

zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' use-fzf-default-opts yes

unset __TREE_IGNORE
unset __FD_COMMAND

# 👇 tv
_tv_search() {
  emulate -L zsh
  zle -I

  local current_prompt
  current_prompt=$LBUFFER

  local output

  output=$(tv --autocomplete-prompt "$current_prompt" $*)

  zle reset-prompt

  if [[ -n $output ]]; then
    RBUFFER=""
    LBUFFER=$current_prompt$output
  fi
}

zle -N tv-search _tv_search

bindkey '^T' tv-search

# 👇 fast-syntax-highlighting
source "$ZSH_PLUGINS_DIR"/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# 👇 zsh options
setopt interactivecomments
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"

autoload -U edit-command-line
zle -N edit-command-line
bindkey "^v" edit-command-line

# 👇 My preferred editor for local and remote sessions
if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
  export EDITOR="nvim"
  export VISUAL="nvim"
elif [[ "$TERM_PROGRAM" == "zed" ]]; then
  export EDITOR="zed --wait"
  export VISUAL="zed --wait"
else
  export EDITOR="nvim"
  export VISUAL="nvim"
fi

# 👇 My keybindings
bindkey "^[f" forward-word
bindkey "^[b" backward-word
bindkey "^A" beginning-of-line
bindkey "^B" backward-char
bindkey "^D" delete-word
bindkey "^E" end-of-line
bindkey "^F" forward-char

# 👇 Custom paths
export PATH="$HOME/dotfiles/bin:$PATH"
source "$HOME/dotfiles/config/shell/functions/misc.zsh"
source "$HOME/dotfiles/config/shell/functions/db.zsh"
source "$HOME/dotfiles/config/shell/functions/g.zsh"
source "$HOME/dotfiles/config/shell/functions/surge.zsh"
export PATH="$HOME/Developer/local/prototypes/utils/bin:$PATH"
export PATH="$HOME/Developer/local/prototypes/utils/bash-scripts:$PATH"

# 👇 Brew
export HOMEBREW_NO_ANALYTICS=1

# 👇 Mojo
export PATH="$HOME/.modular/bin:$PATH"

# 👇 OrbStack
source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :

# 👇 zoxide
eval "$(zoxide init zsh --cmd j)"

# 👇 yazi
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# 👇 atuin
eval "$(atuin init zsh --disable-up-arrow)"

# 👇 mise
eval "$(mise activate zsh)"
