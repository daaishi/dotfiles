#!/bin/bash
# ~/dotfiles/install.sh
# dotfilesのセットアップスクリプト

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"

echo "🚀 dotfilesのセットアップを開始します..."

# oh-my-zshのインストール確認
if [ ! -d "$OH_MY_ZSH_DIR" ]; then
  echo "📦 oh-my-zshをインストールします..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  echo "✅ oh-my-zshのインストールが完了しました"
else
  echo "✅ oh-my-zshは既にインストールされています"
fi

# .zshrcのシンボリックリンク作成
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
  echo "⚠️  $HOME/.zshrcが既に存在します。バックアップを作成します..."
  mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
fi

if [ ! -L "$HOME/.zshrc" ]; then
  echo "🔗 .zshrcのシンボリックリンクを作成します..."
  ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
  echo "✅ .zshrcのシンボリックリンクを作成しました"
else
  echo "✅ .zshrcのシンボリックリンクは既に存在します"
fi

# オプショナル: zsh-autosuggestionsプラグイン
if [ ! -d "$OH_MY_ZSH_DIR/custom/plugins/zsh-autosuggestions" ]; then
  echo "📦 zsh-autosuggestionsプラグインをインストールします..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$OH_MY_ZSH_DIR/custom/plugins/zsh-autosuggestions"
  echo "✅ zsh-autosuggestionsのインストールが完了しました"
  echo "   .zshrcのpluginsに 'zsh-autosuggestions' を追加してください"
fi

# オプショナル: zsh-syntax-highlightingプラグイン
if [ ! -d "$OH_MY_ZSH_DIR/custom/plugins/zsh-syntax-highlighting" ]; then
  echo "📦 zsh-syntax-highlightingプラグインをインストールします..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$OH_MY_ZSH_DIR/custom/plugins/zsh-syntax-highlighting"
  echo "✅ zsh-syntax-highlightingのインストールが完了しました"
  echo "   .zshrcのpluginsに 'zsh-syntax-highlighting' を追加してください"
fi

echo ""
echo "✨ セットアップが完了しました！"
echo ""
echo "次のステップ:"
echo "  1. 新しいターミナルを開くか、以下を実行してください:"
echo "     source ~/.zshrc"
echo ""
echo "  2. オプショナルプラグインを使う場合は、.zshrcのpluginsに追加してください:"
echo "     plugins=(git brew macos zsh-autosuggestions zsh-syntax-highlighting)"
echo ""
echo "  3. マシン固有の設定が必要な場合は、~/.zshrc.local を作成してください"

