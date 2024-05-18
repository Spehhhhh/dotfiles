#===============================================================================
# 👇 Aliases
# 👇 For a full list of active aliases, run `alias`.
#===============================================================================
case $SYSTEM_TYPE in
mac_arm64)
  alias x86_64='arch -x86_64 zsh --login'
  alias x86_64_run='arch -x86_64 zsh -c'
  alias brow='/usr/local/homebrew/bin/brew'
  ;;
esac

#===============================================================================
# 👇
#===============================================================================
alias cpi='cp -i'
alias mvi='mv -i'

#===============================================================================
# 👇
#===============================================================================
alias cat='bat --paging=never'
alias l='lsd'
alias la='lsd -a'
alias ll='lsd -lh'
alias lla='lsd -la'
alias lt='lsd --tree'
if [[ -n $SSH_CONNECTION ]]; then
  alias lsd='lsd --icon never'
fi
alias rmi='rm -i'
alias v='neovide'

#===============================================================================
# 👇
#===============================================================================
alias cwd='printf "%q\n" "$(pwd)" | pbcopy'

alias e-host='${=EDITOR} /etc/hosts'
alias e-ohmyzsh='${=EDITOR} ~/.oh-my-zsh'
alias e-zshrc='${=EDITOR} ~/.zshrc'

alias s-zshrc='source ~/.zshrc'

alias ip='curl -4 ip.sb'
alias ipv6='curl -6 ip.sb'

g-i() {
  git init
  git commit --allow-empty -m "init"
}

g-sync() {
  gh repo list --fork --visibility public --json owner,name | jq -r 'map(.owner.login + "/" + .name) | .[]' | xargs -t -L1 gh repo sync
}

alias r-archivebox='cd /Volumes/Workspace/Databases/ArchiveBox && archivebox server'
alias r-bb='/Applications/OpenBB\ Terminal/OpenBB\ Terminal'
alias r-citespace='cd ${HOME}/Databases/CiteSpace/5.8.R3/ && ./StartCiteSpace_M1_Pro.sh'
alias r-deepl='colima start && docker run -itd -p 8080:80 zu1k/deepl'
alias r-fava='fava ${HOME}/Databases/Ledger/main.bean -p 4000'
alias r-jupyter-lab='${HOME}/.conda/envs/LearningAI/bin/jupyter-lab'
alias r-jupyter='${HOME}/.conda/envs/LearningAI/bin/jupyter-notebook'
alias r-lol='open /Applications/League\ of\ Legends.app/ --args --locale=zh_CN'
alias r-p2t='${HOME}/Databases/Stacks/Utilities/Pix2Text/.venv/bin/python ${HOME}/Databases/Stacks/Utilities/Pix2Text/scripts/screenshot_daemon.py'
alias r-unm='node ${HOME}/Databases/Stacks/Utilities/UnblockNeteaseMusic/app.js -p 80:443 -f 103.126.92.132'

r-update() {
  echo -e "\033[33mUpdating all packages using asdf...\033[0m"
  asdf latest --all

  echo -e "\033[33mChecking for outdated Homebrew formulas...\033[0m"
  brew cu

  echo -e "\033[33mUpdating Homebrew...\033[0m"
  brew update

  echo -e "\033[33mUpdating tldr pages...\033[0m"
  tldr --update
}

r-upgrade() {
  echo -e "\033[33mUpdating all asdf plugins...\033[0m"
  asdf plugin update --all

  echo -e "\033[33mUpdating asdf...\033[0m"
  asdf update

  echo -e "\033[33mUpgrading all Homebrew formulas...\033[0m"
  brew upgrade

  echo -e "\033[33mUpdating all Rust crates...\033[0m"
  cargo install-update --all

  echo -e "\033[33mUpgrading all GitHub CLI extensions...\033[0m"
  gh extension upgrade --all

  echo -e "\033[33mUpgrading all macOS applications...\033[0m"
  mas upgrade

  echo -e "\033[33mChecking and updating global npm packages...\033[0m"
  npx npm-check --global --update-all

  echo -e "\033[33mUpdating Oh My Zsh...\033[0m"
  omz update

  echo -e "\033[33mUpgrading Python pip and all pipx packages...\033[0m"
  python -m pip install --upgrade pip
  pipx upgrade-all

  echo -e "\033[33mUpdating Rust toolchain...\033[0m"
  rustup self update
  rustup update

  echo -e "\033[33mDownloading and setting permissions for ai.py script...\033[0m"
  wget https://raw.githubusercontent.com/reorx/ai.py/master/ai.py -O "${HOME}"/Dotfiles/bin/ai && chmod +x "${HOME}"/Dotfiles/bin/ai
}

r-backup() {
  echo -e "\033[33mUpdating Homebrew before backup...\033[0m"
  brew update

  echo -e "\033[33mDumping Homebrew bundle...\033[0m"
  brew bundle dump --file="$HOME"/dotfiles/assets/others/packages/Brewfile --force

  echo -e "\033[33mCreating list of installed Homebrew leaves...\033[0m"
  brew leaves >"$HOME"/dotfiles/assets/others/packages/Brewfile.txt

  echo -e "\033[33mListing installed Cargo packages...\033[0m"
  cargo install --list | grep -v '^[[:blank:]]' | awk '{print $1}' >"$HOME"/dotfiles/assets/others/packages/cargo.txt

  echo -e "\033[33mListing installed Mac applications...\033[0m"
  ls /Applications | rg '\.app' | sed 's/\.app//g' >"$HOME"/dotfiles/assets/others/packages/macos_applications.txt

  echo -e "\033[33mListing installed Setapp applications...\033[0m"
  ls /Applications/Setapp | rg '\.app' | sed 's/\.app//g' >"$HOME"/dotfiles/assets/others/packages/macos_setapp.txt

  echo -e "\033[33mCreating npm global packages list...\033[0m"
  npm list --location=global --json | jq ".dependencies | keys[]" -r >"$HOME"/dotfiles/assets/others/packages/npm.txt

  echo -e "\033[33mListing pipx managed packages...\033[0m"
  pipx list --json | jq ".venvs | .[] | .metadata.main_package.package" -r >"$HOME"/dotfiles/assets/others/packages/pipx.txt

  echo -e "\033[33mListing Visual Studio Code extensions...\033[0m"
  code --list-extensions >"$HOME"/dotfiles/assets/others/packages/vscode_extensions.txt

  echo -e "\033[33mBacking up .zsh_history...\033[0m"
  cp "$HOME"/.zsh_history "$HOME"/Databases/Backup/CLI/zsh_history_$(date +\%Y_\%m_\%d_\%H_\%M_\%S).bak
}
