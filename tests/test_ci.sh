#!/usr/bin/env bash

# set -e

source "$HOME"/dotfiles/bin/csys # check SYSTEM_OS
echo "$ZSH_NAME" "$ZSH_VERSION"

echo "Testing"
echo "Testing Git"
test -x "$(which git)"

case "$SYSTEM_OS" in
mac)
  # python --version | grep --fixed-strings "Python 3.10.2"
  # "$(brew --prefix)"/bin/zsh -c "python --version" | grep --fixed-strings "Python 3.10.2"
  # which python | rg "shims"
  # echo "Testing Mackup"

  ;;
*)
  echo "unknown $SYSTEM_OS"
  ;;
esac

echo "Testing Homebrew"
test -x "$(which brew)"

cat "$HOME"/.zshrc
test -f "$HOME"/.zshrc

cat "$HOME"/.zprofile
test -f "$HOME"/.zprofile
