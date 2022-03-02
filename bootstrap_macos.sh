#!/bin/zsh

# main_arm64
function main_arm64 {
  echo "Installing dotfiles for arm64"
  
  # install oh-my-zsh
  export CHSH=no
  export RUNZSH=no
  export KEEP_ZSHRC=yes
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended --keep-zshrc

  # install zsh
  grep --fixed-strings "dotfiles/config/shell/init.sh" ~/.zshrc || mv "$HOME"/.zshrc "$HOME"/.zshrc.bak && touch "$HOME"/.zshrc && echo "source $HOME/dotfiles/config/shell/init.sh" >> "$HOME"/.zshrc
  mv "$HOME"/.zprofile "$HOME"/.zprofile.bak && touch "$HOME"/.zprofile && cp "$HOME"/dotfiles/config/shell/macos/zprofile.sh "$HOME"/.zprofile
  
  # install zsh plugins
  git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
  git clone https://github.com/paulirish/git-open.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/git-open
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
  git clone https://github.com/sukkaw/zsh-osx-autoproxy ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-osx-autoproxy
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  # install Homebrew
  which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # install Homebrew packages
  eval "$(/opt/homebrew/bin/brew shellenv)"
  source $HOME/.zshrc
  brew bundle --file="$HOME"/dotfiles/assets/brew/BrewfileDev

  # install mackup
  ln -sf "$HOME"/dotfiles/config/mackup/.mackup.cfg "$HOME"/.mackup.cfg
  ln -sf "$HOME"/dotfiles/config/mackup/.mackup "$HOME"/.mackup
  mackup restore

  # install asdf
  asdf plugin-add clojure https://github.com/asdf-community/asdf-clojure.git
  asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
  asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf plugin-add php https://github.com/asdf-community/asdf-php.git
  asdf plugin-add python
  asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
  asdf plugin-add rust https://github.com/asdf-community/asdf-rust.git
  asdf install

  # install npm packages
  xargs npm install --global < "$HOME"/dotfiles/assets/npm/npm.txt

  # install pipx packages
  cat "$HOME"/dotfiles/assets/pipx/pipx.txt | xargs -n 1 pipx install

  # install other packages
  curl -sSL https://git.io/JcGER | bash # AutoCorrect

  # install oh-my-tmux
  git clone https://github.com/gpakosz/.tmux.git "$HOME"/.tmux
  ln -sf "$HOME"/.tmux/.tmux.conf "$HOME"/.tmux.conf

  # install SpaceVim
  curl -sLf https://spacevim.org/install.sh | bash

  # install doom-emacs
  # git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
  # ~/.emacs.d/bin/doom install
}

# init
arch_check=$(/usr/bin/arch)
case $arch_check in
  arm64*)
    main_arm64
    echo "Done"
  ;;
  i386*)
    echo "Please check the path to miniforge in init.sh"
  ;;
  *)
    echo "unknown: $arch_check"
  ;;
esac
