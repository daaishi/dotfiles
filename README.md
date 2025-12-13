# dotfiles

複数のMacで使用するzsh設定ファイルのリポジトリです。oh-my-zshを使用しています。

## セットアップ

### 自動セットアップ（推奨）

```bash
git clone https://github.com/shoichiishida/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

このスクリプトは以下を自動で行います：
- oh-my-zshのインストール（未インストールの場合）
- `.zshrc`のシンボリックリンク作成
- オプショナルプラグインのインストール（zsh-autosuggestions、zsh-syntax-highlighting）

### 手動セットアップ

#### 1. oh-my-zshのインストール

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### 2. リポジトリをクローン

```bash
git clone https://github.com/shoichiishida/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

#### 3. シンボリックリンクを作成

```bash
ln -s ~/dotfiles/.zshrc ~/.zshrc
```

#### 4. ローカル設定ファイル（オプション）

マシン固有の設定が必要な場合は、`~/.zshrc.local` を作成してください。
このファイルは `.gitignore` に含まれているため、Gitにコミットされません。

```bash
touch ~/.zshrc.local
```

## 構成

- `.zshrc` - メインのzsh設定ファイル（oh-my-zsh使用）
- `install.sh` - セットアップスクリプト
- `.gitignore` - Gitで無視するファイル
- `README.md` - このファイル

## 含まれるプラグイン

デフォルトで以下のプラグインが有効になっています：

- **git** - Gitのエイリアスと関数
- **brew** - Homebrewの補完
- **macos** - macOS固有の便利な関数
- **docker** - Dockerの補完
- **kubectl** - Kubernetesの補完
- **colored-man-pages** - カラフルなmanページ
- **command-not-found** - コマンドが見つからない場合の提案

## オプショナルプラグイン

以下のプラグインは`install.sh`で自動インストールされますが、`.zshrc`の`plugins`に追加する必要があります：

- **zsh-autosuggestions** - コマンド履歴の自動提案
- **zsh-syntax-highlighting** - シンタックスハイライト

追加方法：
```bash
plugins=(
  git
  brew
  macos
  zsh-autosuggestions
  zsh-syntax-highlighting
)
```

## テーマ

デフォルトでは`robbyrussell`テーマを使用しています。変更する場合は、`.zshrc`の`ZSH_THEME`を編集してください。

利用可能なテーマ: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

## カスタマイズ

### プラグインの追加

`.zshrc`の`plugins`配列に追加するだけです：

```bash
plugins=(git brew macos 新しいプラグイン名)
```

### カスタム関数の追加

`.zshrc`の「カスタム関数」セクションに追加してください。

## 更新

設定を更新した後、以下のコマンドで反映できます：

```bash
source ~/.zshrc
```

