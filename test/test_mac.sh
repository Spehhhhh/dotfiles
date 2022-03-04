#!/bin/zsh

set -e

echo "Testing for macOS"

echo "Testing Homebrew"
test -x "$(which brew)"
test -x "$(which git)"
test -x "$(which code)" # VSCode

echo "Testing oh-my-zsh"
test -x "$(which zsh)"
test -d "$HOME"/.oh-my-zsh
