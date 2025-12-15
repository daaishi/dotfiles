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

# エイリアス（oh-my-zshのgitプラグインと重複するものは除く）
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
# 安全なコマンド
alias rm='rm -i'                  # 削除前に確認
alias cp='cp -i'                  # 上書き前に確認
alias mv='mv -i'                  # 上書き前に確認
# 便利なエイリアス
alias h='history'
alias c='clear'
alias reload='source ~/.zshrc'    # 設定を再読み込み
alias path='echo $PATH | tr ":" "\n"'  # パスを改行区切りで表示

# AWS設定
export AWS_SHARED_CREDENTIALS_FILE="$HOME/.aws/credentials"
export AWS_CONFIG_FILE="$HOME/.aws/config"

# デフォルトでSSOプロファイルを使用（明示的に設定）
# 新しいターミナルでは常に ws-proto を使用
if [ -z "$AWS_PROFILE" ] || [[ "$AWS_PROFILE" == *"copilot"* ]] || [[ "$AWS_PROFILE" == *"Wonder-Screen-Dev"* ]]; then
  export AWS_PROFILE="ws-proto"
fi

# AWSプロファイルをプロンプトに表示する関数
aws_prompt_info() {
  local profile="${AWS_PROFILE:-default}"
  if [ -n "$profile" ]; then
    echo "%{$fg_bold[yellow]%}[AWS: $profile]%{$reset_color%} "
  fi
}

# AWSエイリアス
alias aws-profile='aws configure list-profiles'
alias aws-whoami='aws sts get-caller-identity'

# AWS SSO認証チェック関数
aws-check-auth() {
  local profile="${AWS_PROFILE:-default}"
  
  echo "🔍 AWS SSO認証状態の確認 (プロファイル: $profile)"
  echo ""

  # SSOセッションの状態確認
  if aws sts get-caller-identity &> /dev/null; then
    echo "✅ AWS認証情報が有効です"
    aws sts get-caller-identity
    return 0
  else
    echo "❌ AWS認証情報が無効、または期限切れです"
    echo ""
    echo "SSOログインを試みます..."
    echo "実行コマンド: aws sso login --profile $profile"
    
    if aws sso login --profile "$profile"; then
      echo ""
      echo "✅ SSOログインに成功しました"
      aws sts get-caller-identity
      return 0
    else
      echo ""
      echo "❌ SSOログインに失敗しました"
      return 1
    fi
  fi
}

# AWSプロファイル切り替え関数（aws-switchコマンド）
aws-switch() {
  local profiles
  local selected_profile
  local profile_count

  # プロファイル一覧を取得
  profiles=($(aws configure list-profiles 2>/dev/null))
  
  if [ ${#profiles[@]} -eq 0 ]; then
    echo "❌ プロファイルが見つかりません"
    return 1
  fi

  # 引数が指定されている場合
  if [ -n "$1" ]; then
    # プロファイルが存在するか確認
    if printf '%s\n' "${profiles[@]}" | grep -q "^$1$"; then
      export AWS_PROFILE="$1"
      echo "✅ AWSプロファイルを '$1' に切り替えました"
      echo ""
      # 認証情報の確認
      aws-check-auth
      return 0
    else
      echo "❌ プロファイル '$1' が見つかりません"
      echo ""
      echo "利用可能なプロファイル:"
      printf '  - %s\n' "${profiles[@]}"
      return 1
    fi
  fi

  # 対話的にプロファイルを選択
  echo "利用可能なAWSプロファイル:"
  echo ""
  profile_count=1
  for profile in "${profiles[@]}"; do
    if [ "$profile" = "$AWS_PROFILE" ]; then
      echo "  [$profile_count] $profile (現在選択中) ⭐"
    else
      echo "  [$profile_count] $profile"
    fi
    ((profile_count++))
  done
  echo ""
  echo -n "プロファイルを選択してください [1-${#profiles[@]}]: "
  read -r selection

  # 選択が有効か確認
  if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt ${#profiles[@]} ]; then
    echo "❌ 無効な選択です"
    return 1
  fi

  selected_profile="${profiles[$selection]}"
  export AWS_PROFILE="$selected_profile"
  echo ""
  echo "✅ AWSプロファイルを '$selected_profile' に切り替えました"
  echo ""
  # 認証情報の確認
  aws-check-auth
}

# 後方互換性のため、aws-profile-setも残す
aws-profile-set() {
  aws-switch "$@"
}

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

# カスタム関数
# ディレクトリサイズを表示
ds() {
  du -sh "$@" 2>/dev/null | sort -h
}

# ディレクトリを作成して移動
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# 現在のディレクトリをGitHubで開く（GitHub CLI使用時）
gh-open() {
  if command -v gh &> /dev/null; then
    gh repo view --web
  else
    echo "GitHub CLI (gh) がインストールされていません"
  fi
}

# プロセスをポート番号で検索
port() {
  if [ -z "$1" ]; then
    echo "使用方法: port <ポート番号>"
    return 1
  fi
  lsof -i :"$1"
}

# ヘルプコマンド
help() {
  echo "📚 利用可能なカスタムコマンドとエイリアス"
  echo ""
  
  echo "🚀 AWS関連"
  echo "  aws-switch      : AWSプロファイルの切り替え"
  echo "  aws-profile     : プロファイル一覧を表示"
  echo "  aws-whoami      : 現在の認証情報を表示"
  echo "  aws-check-auth  : SSO認証状態を確認・ログイン"
  echo ""
  
  echo "🛠  ユーティリティ"
  echo "  mkcd <dir>      : ディレクトリを作成して移動"
  echo "  ds <dir>        : ディレクトリサイズを表示"
  echo "  port <port>     : 指定ポートを使用中のプロセスを検索"
  echo "  gh-open         : 現在のリポジトリをGitHubで開く"
  echo "  reload          : 設定ファイル(.zshrc)を再読み込み"
  echo "  path            : PATHを見やすく表示"
  echo ""
  
  echo "⚡️ 短縮エイリアス"
  echo "  ll, la, l       : lsコマンドのバリエーション"
  echo "  .., ..., ....   : ディレクトリ階層を上がる"
  echo "  h               : 履歴表示 (history)"
  echo "  c               : 画面クリア (clear)"
  echo ""
  
  echo "💡 Tips"
  echo "  Ctrl+R          : 履歴検索"
  echo "  Option+Arrows   : 単語単位で移動"
}

# 補完キャッシュディレクトリの作成
if [ ! -d ~/.zsh/cache ]; then
  mkdir -p ~/.zsh/cache
fi

# ローカル設定があれば読み込む（マシン固有の設定用）
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
