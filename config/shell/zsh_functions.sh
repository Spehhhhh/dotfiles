#===============================================================================
# 👇 1Password
#===============================================================================
opon() {
  if [[ -z $OP_SESSION_my ]]; then
    eval "$(op signin --account my)"
  fi
}
opoff() {
  op signout
  unset OP_SESSION_my
}
getkey() {
  opon
  op item get id_rsa_macbook_14 --format json | jq '.fields | map(select(.id == "private_key")) | .[0] | .value' -r | ssh-add -
  opoff
}
remkey() {
  ssh-add -D
}

#===============================================================================
# 👇 sudo Ctrl-S
#===============================================================================
sudo-command-line() {
  [[ -z $BUFFER ]] && zle up-history
  local cmd="sudo "
  if [[ ${BUFFER} == ${cmd}* ]]; then
    CURSOR=$(( CURSOR-${#cmd} ))
    BUFFER="${BUFFER#"$cmd"}"
  else
    BUFFER="${cmd}${BUFFER}"
    CURSOR=$(( CURSOR+${#cmd} ))
  fi
  zle reset-prompt
}
zle -N sudo-command-line

#===============================================================================
# 👇 Git
#===============================================================================
getrepo() {
  git clone "$1" && cd "$(basename "$1" .git)" || exit
}

#===============================================================================
# 👇 fzf Option-X 跳转近期目录
#===============================================================================
fzf-dirs-widget() {
  dir=$(dirs -v | fzf --height "${FZF_TMUX_HEIGHT:-40%}" --reverse | cut -b3-)
  local dir
  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  eval cd "${dir}"
  local ret=$?
  unset dir # ensure this doesn't end up appearing in prompt expansion
  zle reset-prompt
  return $ret
}
zle -N fzf-dirs-widget

#===============================================================================
# 👇 fzf completion will use ~~ as the trigger sequence instead of the default **
# 👇 Ctrl-I will be used to trigger completion
#===============================================================================
export FZF_COMPLETION_TRIGGER='~~'
export FZF_COMPLETION_OPTS='--border --info=inline'
_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf "$@" ;;
  esac
}

#===============================================================================
# 👇 fzf 浏览器历史记录
#===============================================================================
fch() {
  local cols sep google_history open
  cols=$(( COLUMNS / 3 ))
  sep='{::}'

  if [ "$(uname)" = "Darwin" ]; then
    google_history="$HOME/Library/Application Support/Google/Chrome/Default/History"
    open=open
  else
    google_history="$HOME/.config/google-chrome/Default/History"
    open=xdg-open
  fi
  cp -f "$google_history" /tmp/h
  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
    from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs $open > /dev/null 2> /dev/null
}

#===============================================================================
# 👇 fzf 浏览器书签
#===============================================================================
fcb() {
    bookmarks_path=~/Library/Application\ Support/Google/Chrome/Default/Bookmarks
    jq_script='
        def ancestors: while(. | length >= 2; del(.[-1,-2]));
        . as $in | paths(.url?) as $key | $in | getpath($key) | {name,url, path: [$key[0:-2] | ancestors as $a | $in | getpath($a) | .name?] | reverse | join("/") } | .path + "/" + .name + "\t" + .url'
    jq -r "$jq_script" < "$bookmarks_path" \
        | sed -E $'s/(.*)\t(.*)/\\1\t\x1b[36m\\2\x1b[m/g' \
        | fzf --ansi \
        | cut -d$'\t' -f2 \
        | xargs open
}

#===============================================================================
# 👇 fzf 杀进程
#===============================================================================
fkill() {
  (date; ps -ef) |
    fzf --bind='ctrl-r:reload(date; ps -ef)' \
        --header=$'Press CTRL-R to reload\n\n' --header-lines=2 \
        --preview='echo {}' --preview-window=down,3,wrap \
        --layout=reverse --height=80% | awk '{print $2}' | xargs kill -9
}

#===============================================================================
# 👇 fzf z
#===============================================================================
# z foo<tab> # shows the same completions as cd
# z foo<space><tab> # shows interactive completions via zoxide

#===============================================================================
# 👇 fzf asdf
#===============================================================================
# ref fasdf()

#===============================================================================
# 👇 tmux
#===============================================================================
tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ "$1" ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}
tmkill() {
    local sessions
    sessions="$(tmux ls|fzf --exit-0 --multi)"  || return $?
    local i
    for i in "${(f@)sessions}"
    do
        [[ $i =~ '([^:]*):.*' ]] && {
            echo "Killing $match[1]"
            tmux kill-session -t "$match[1]"
        }
    done
}

#===============================================================================
# 👇 cd
#===============================================================================
cd() {
    if [[ "$#" != 0 ]]; then
        builtin cd "$@";
        return
    fi
    while true; do
        local lsd=$(echo ".." && ls -p | grep '/$' | sed 's;/$;;')
        local dir="$(printf '%s\n' "${lsd[@]}" |
            fzf --reverse --preview '
                __cd_nxt="$(echo {})";
                __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
                echo $__cd_path;
                echo;
                ls -p --color=always "${__cd_path}";
        ')"
        [[ ${#dir} != 0 ]] || return 0
        builtin cd "$dir" &> /dev/null
    done
}

#===============================================================================
# 👇 https://github.com/xbin-io/xbin/
#===============================================================================
function xbin() {
  command="$1"
  shift
  args=( "$@" )
  if [ -t 0 ]; then
    curl -sS -X POST "https://xbin.io/${command}" -H "X-Args: ${args}"
  else
    curl -sS --data-binary @- "https://xbin.io/${command}" -H "X-Args: ${args}"
  fi
}

#===============================================================================
# 👇 https://kadekillary.work/posts/1000x-eng/
# Examples of efficient data analysis using shell scripts
# hgpt "create a 10 row csv of NBA player data with headers - please only include the data, nothing else" > nba.csv
# dgpt "can you write a sql query to get the average PointsPerGame by Position from the following" "$(cat nba.csv)"
#===============================================================================
function hgpt {
    local prompt=$1

    ai "$prompt"
}
function dgpt() {
    local prompt=$1
    local data=$2
    local prompt=$(echo "${prompt}: ${data}" | tr -s ' ')

    ai "$prompt"
}
