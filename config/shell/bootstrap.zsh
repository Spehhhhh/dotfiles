SYSTEM_ARCH=$(uname -m)

case "$OSTYPE" in
darwin*)
  case $SYSTEM_ARCH in
  arm64*)
    SYSTEM_TYPE="mac_arm64"
    ;;
  x86_64*)
    SYSTEM_TYPE="mac_x86_64"
    ;;
  *)
    SYSTEM_TYPE="unknown"
    ;;
  esac
  ;;
linux*)
  case $SYSTEM_ARCH in
  x86_64*)
    SYSTEM_TYPE="linux_x86_64"
    ;;
  *armv7l*)
    SYSTEM_TYPE="raspberry"
    ;;
  *)
    SYSTEM_TYPE="unknown"
    ;;
  esac
  ;;
msys*)
  SYSTEM_TYPE="unknown"
  ;;
*)
  SYSTEM_TYPE="unknown"
  ;;
esac

export SYSTEM_TYPE

case $SYSTEM_TYPE in
mac_arm64 | mac_x86_64 | linux_x86_64 | raspberry)
  if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
    if [[ $- == *i* ]] && [ -z "$_INIT_SH_NOFUN" ]; then
      local config_files=(
        "$HOME/dotfiles/config/shell/env.zsh"
        "$HOME/dotfiles/config/shell/env_private.zsh"
        "$HOME/dotfiles/config/shell/aliases.zsh"
        "$HOME/dotfiles/config/shell/functions/ai.zsh"
        "$HOME/dotfiles/config/shell/functions/db.zsh"
        "$HOME/dotfiles/config/shell/functions/misc.zsh"
      )

      for file in "${config_files[@]}"; do
        [[ -f "$file" ]] && source "$file"
      done
    fi
  fi
  ;;
unknown)
  echo "${RED}Unsupported system architecture.${NORMAL}"
  ;;
esac
