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

# AWS設定のセットアップ
echo ""
echo "☁️  AWS設定をセットアップします..."

# AWS CLIのインストール確認
if ! command -v aws &> /dev/null; then
  echo "📦 AWS CLIがインストールされていません。インストールします..."
  
  # Homebrewがインストールされているか確認
  if ! command -v brew &> /dev/null; then
    echo "❌ Homebrewがインストールされていません"
    echo "   Homebrewをインストールしてから、以下を実行してください:"
    echo "   brew install awscli"
    echo ""
    echo "   または、AWS公式のインストーラーを使用してください:"
    echo "   https://aws.amazon.com/cli/"
  else
    echo "   HomebrewでAWS CLIをインストールします..."
    brew install awscli
    echo "✅ AWS CLIのインストールが完了しました"
  fi
else
  echo "✅ AWS CLIがインストールされています ($(aws --version))"
fi

# AWS Copilot CLIのインストール確認
if ! command -v copilot &> /dev/null; then
  echo "📦 AWS Copilot CLIがインストールされていません。インストールします..."
  
  # Homebrewがインストールされているか確認
  if ! command -v brew &> /dev/null; then
    echo "❌ Homebrewがインストールされていません"
    echo "   Homebrewをインストールしてから、以下を実行してください:"
    echo "   brew install aws/tap/copilot-cli"
  else
    echo "   HomebrewでAWS Copilot CLIをインストールします..."
    brew install aws/tap/copilot-cli
    echo "✅ AWS Copilot CLIのインストールが完了しました"
  fi
else
  echo "✅ AWS Copilot CLIがインストールされています ($(copilot --version))"
fi

# ~/.awsディレクトリの作成
if [ ! -d "$HOME/.aws" ]; then
  mkdir -p "$HOME/.aws"
  echo "✅ ~/.awsディレクトリを作成しました"
fi

# AWS configのシンボリックリンク作成
if [ -f "$HOME/.aws/config" ] && [ ! -L "$HOME/.aws/config" ]; then
  echo "⚠️  $HOME/.aws/configが既に存在します。バックアップを作成します..."
  mv "$HOME/.aws/config" "$HOME/.aws/config.backup.$(date +%Y%m%d_%H%M%S)"
fi

if [ ! -L "$HOME/.aws/config" ]; then
  echo "🔗 AWS configのシンボリックリンクを作成します..."
  ln -sf "$DOTFILES_DIR/aws/config" "$HOME/.aws/config"
  echo "✅ AWS configのシンボリックリンクを作成しました"
else
  echo "✅ AWS configのシンボリックリンクは既に存在します"
fi

# AWS認証情報取得スクリプトのセットアップ
if [ -f "$HOME/.aws/get-credentials.sh" ] && [ ! -L "$HOME/.aws/get-credentials.sh" ]; then
  echo "⚠️  $HOME/.aws/get-credentials.shが既に存在します。バックアップを作成します..."
  mv "$HOME/.aws/get-credentials.sh" "$HOME/.aws/get-credentials.sh.backup.$(date +%Y%m%d_%H%M%S)"
fi

if [ ! -L "$HOME/.aws/get-credentials.sh" ]; then
  echo "🔗 AWS認証情報取得スクリプトのシンボリックリンクを作成します..."
  ln -sf "$DOTFILES_DIR/aws/get-credentials.sh" "$HOME/.aws/get-credentials.sh"
  chmod +x "$HOME/.aws/get-credentials.sh"
  echo "✅ AWS認証情報取得スクリプトのシンボリックリンクを作成しました"
else
  echo "✅ AWS認証情報取得スクリプトのシンボリックリンクは既に存在します"
fi

# 1Password CLIの確認
if command -v op &> /dev/null; then
  echo "✅ 1Password CLIがインストールされています"
  if op whoami &> /dev/null; then
    echo "✅ 1Passwordにサインイン済みです"
  else
    echo "⚠️  1Passwordにサインインしてください: op signin"
  fi
else
  echo "⚠️  1Password CLIがインストールされていません"
  echo "   Homebrewでインストール: brew install --cask 1password-cli"
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
echo "  3. AWS CLIのセットアップ（未インストールの場合）:"
echo "     brew install awscli"
echo ""
echo "  4. 1Password CLIのセットアップ:"
echo "     - 1Password CLIが未インストールの場合: brew install --cask 1password-cli"
echo "     - 1Passwordにサインイン: op signin"
echo "     - 1PasswordにAWS認証情報アイテムを作成:"
echo "       * Private/AWS-Default (defaultプロファイル用)"
echo "       * Private/AWS-Wonder-Screen-Dev_copilot-user (Wonder-Screen-Dev_copilot-userプロファイル用)"
echo "       * 各アイテムに 'credential' フィールド (Access Key ID) と 'secret' フィールド (Secret Access Key) を追加"
echo ""
echo "  5. AWSプロファイルの切り替え:"
echo "     aws-switch                    # 対話的にプロファイルを選択"
echo "     aws-switch <プロファイル名>   # 直接プロファイルを指定"
echo ""
echo "  6. マシン固有の設定が必要な場合は、~/.zshrc.local を作成してください"

