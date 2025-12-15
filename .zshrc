# ~/dotfiles/.zshrc
# Source: https://github.com/shoichiishida/dotfiles

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# oh-my-zshの設定
# 自動更新の設定（手動更新を推奨）
DISABLE_AUTO_UPDATE="false"          # 自動更新を有効化
DISABLE_UPDATE_PROMPT="true"         # 更新プロンプトを無効化（自動更新する）
DISABLE_MAGIC_FUNCTIONS="true"       # パス展開の互換性のため無効化（zsh 5.4+）

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

# プロンプトにAWSプロファイルを表示（テーマ読み込み後に設定）
PROMPT='$(aws_prompt_info)%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

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
# 大文字小文字を区別しない補完
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# 補完候補に色を付ける
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# 補完メニューを選択可能にする
zstyle ':completion:*' menu select
# 補完候補をグループ化
zstyle ':completion:*' group-name ''
# 補完候補の説明を表示
zstyle ':completion:*' format '%B%d%b'
# 補完候補をキャッシュ
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache
# 補完候補を詳細に表示
zstyle ':completion:*' verbose yes
# 補完候補をアルファベット順にソート
zstyle ':completion:*' sort false

# ディレクトリ移動の改善
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# その他の便利な設定
setopt CORRECT                    # コマンドのスペルチェック
setopt CORRECT_ALL                # 引数もスペルチェック
setopt EXTENDED_GLOB              # 拡張グロブを有効化
setopt NO_BEEP                    # ビープ音を無効化
setopt COMPLETE_IN_WORD           # 単語の途中でも補完
setopt ALWAYS_TO_END              # 補完後にカーソルを末尾に移動
setopt LIST_PACKED                # 補完候補を詰めて表示
setopt LIST_ROWS_FIRST            # 補完候補を横方向に並べる
setopt AUTO_LIST                  # 補完候補を自動表示
setopt AUTO_MENU                  # Tabキーで補完メニューを表示
setopt AUTO_PARAM_SLASH           # ディレクトリ名の補完で末尾の/を自動追加
setopt AUTO_REMOVE_SLASH          # 末尾の/を自動削除
setopt MARK_DIRS                  # ディレクトリ名の末尾に/を表示
setopt NUMERIC_GLOB_SORT          # 数値順にソート
setopt MULTIOS                    # 複数のリダイレクトを許可
setopt INTERACTIVE_COMMENTS       # コマンドラインでコメントを許可
setopt LONG_LIST_JOBS             # jobsコマンドでプロセスIDも表示
setopt NOTIFY                     # バックグラウンドジョブの状態変化を即座に通知

# 言語設定
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

# パス設定
# Homebrewのパス（Apple Silicon Macの場合）
if [ -d "/opt/homebrew/bin" ]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi
# ローカルbinディレクトリ
export PATH="$HOME/.local/bin:$PATH"

# 分割した設定ファイルを読み込む
# dotfilesリポジトリ内の.zshディレクトリから読み込む
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

# AWS設定と関数
[ -f "$DOTFILES_DIR/.zsh/aws.zsh" ] && source "$DOTFILES_DIR/.zsh/aws.zsh"

# エイリアス
[ -f "$DOTFILES_DIR/.zsh/aliases.zsh" ] && source "$DOTFILES_DIR/.zsh/aliases.zsh"

# カスタム関数
[ -f "$DOTFILES_DIR/.zsh/functions.zsh" ] && source "$DOTFILES_DIR/.zsh/functions.zsh"

# キーバインド設定
# 履歴検索で部分一致
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
# 単語単位での移動（Option + 矢印キー）
bindkey '^[b' backward-word
bindkey '^[f' forward-word
# 行頭・行末への移動
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
# 補完メニューの操作
bindkey '^[[Z' reverse-menu-complete  # Shift+Tabで逆方向に補完

# 補完キャッシュディレクトリの作成
if [ ! -d ~/.zsh/cache ]; then
  mkdir -p ~/.zsh/cache
fi

# ローカル設定があれば読み込む（マシン固有の設定用）
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
