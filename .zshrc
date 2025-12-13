# ~/dotfiles/.zshrc
# Source: https://github.com/shoichiishida/dotfiles

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# テーマ設定
# 利用可能なテーマ: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# プラグイン設定
# 標準プラグインは ~/.oh-my-zsh/plugins/ にあります
# カスタムプラグインは ~/.oh-my-zsh/custom/plugins/ に追加できます
# 例: plugins=(rails git textmate ruby lighthouse)
# よく使われるプラグイン:
#   git: Gitのエイリアスと関数
#   docker: Dockerの補完
#   kubectl: Kubernetesの補完
#   brew: Homebrewの補完
#   macos: macOS固有の便利な関数
#   zsh-autosuggestions: コマンド履歴の自動提案（要インストール）
#   zsh-syntax-highlighting: シンタックスハイライト（要インストール）
plugins=(
  git
  brew
  macos
  docker
  kubectl
  colored-man-pages
  command-not-found
)

# oh-my-zshを読み込む
source $ZSH/oh-my-zsh.sh

# ユーザー設定

# 履歴設定
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY

# 補完設定の改善
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

# ディレクトリ移動の改善
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# その他の便利な設定
setopt CORRECT
setopt EXTENDED_GLOB
setopt NO_BEEP

# エイリアス（oh-my-zshのgitプラグインと重複するものは除く）
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# カスタム関数
# 例: ディレクトリサイズを表示
ds() {
  du -sh "$@" 2>/dev/null | sort -h
}

# ローカル設定があれば読み込む（マシン固有の設定用）
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
