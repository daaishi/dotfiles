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

# AWS設定
export AWS_SHARED_CREDENTIALS_FILE="$HOME/.aws/credentials"
export AWS_CONFIG_FILE="$HOME/.aws/config"

# デフォルトでWonder-Screen-Dev_copilot-userプロファイルを使用
export AWS_PROFILE="Wonder-Screen-Dev_copilot-user"

# AWSエイリアス
alias aws-profile='aws configure list-profiles'
alias aws-whoami='aws sts get-caller-identity'

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
      aws sts get-caller-identity 2>/dev/null || echo "⚠️  認証情報の取得に失敗しました。1Passwordにサインインしてください: op signin"
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
  aws sts get-caller-identity 2>/dev/null || echo "⚠️  認証情報の取得に失敗しました。1Passwordにサインインしてください: op signin"
}

# 後方互換性のため、aws-profile-setも残す
aws-profile-set() {
  aws-switch "$@"
}

# カスタム関数
# 例: ディレクトリサイズを表示
ds() {
  du -sh "$@" 2>/dev/null | sort -h
}

# ローカル設定があれば読み込む（マシン固有の設定用）
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
