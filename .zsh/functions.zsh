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
  echo "  aws-env         : 現在のAWS環境情報を詳細表示"
  echo "  aws-resources   : 構築されている環境・リソース一覧を表示"
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
