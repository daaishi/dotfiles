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
- `aws/config` - AWS CLI設定ファイル（プロファイル設定）
- `aws/get-credentials.sh` - 1Password CLIから認証情報を取得するスクリプト
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

## AWS設定

### 前提条件

#### AWS CLIのインストール

AWS CLIがインストールされていない場合、`install.sh`が自動的にインストールを試みます。手動でインストールする場合：

```bash
# Homebrewを使用（推奨）
brew install awscli

# または、AWS公式インストーラーを使用
# https://aws.amazon.com/cli/
```

### 1Password CLI統合

AWS認証情報は1Password CLIで管理されます。認証情報をファイルに保存する必要はありません。

#### セットアップ

1. **1Password CLIのインストール**（未インストールの場合）:
   ```bash
   brew install --cask 1password-cli
   ```

2. **1Passwordにサインイン**:
   ```bash
   op signin
   ```

3. **1PasswordにAWS認証情報アイテムを作成**:
   
   各AWSプロファイルごとに、1Passwordに以下のアイテムを作成してください：
   - **Vault**: Private（または任意のVault名）
   - **アイテム名**: `AWS-<プロファイル名>`
     - 例: `AWS-Default`
     - 例: `AWS-Wonder-Screen-Dev_copilot-user`
   - **フィールド**:
     - `credential` - AWS Access Key ID
     - `secret` - AWS Secret Access Key

   1Password CLIで作成する場合:
   ```bash
   op item create \
     --category "Secure Note" \
     --title "AWS-Wonder-Screen-Dev_copilot-user" \
     --vault Private \
     credential="YOUR_ACCESS_KEY_ID" \
     secret="YOUR_SECRET_ACCESS_KEY"
   ```

### プロファイル管理

デフォルトで`Wonder-Screen-Dev_copilot-user`プロファイルが使用されます。

#### 利用可能なコマンド

- `aws-switch` - 対話的にプロファイルを切り替え
- `aws-switch <プロファイル名>` - 指定したプロファイルに切り替え
- `aws-profile` - 利用可能なプロファイル一覧を表示
- `aws-whoami` - 現在のAWSアカウント情報を表示

#### プロファイルの切り替え

```bash
# 対話的にプロファイルを選択
aws-switch

# 直接プロファイルを指定
aws-switch Wonder-Screen-Dev_copilot-user
aws-switch default
```

#### 新しいプロファイルの追加

1. `aws/config`にプロファイルを追加:
   ```ini
   [profile 新しいプロファイル名]
   region = ap-northeast-1
   output = json
   credential_process = ~/.aws/get-credentials.sh
   ```

2. 1Passwordに認証情報アイテムを作成:
   - アイテム名: `AWS-新しいプロファイル名`
   - Vault: Private
   - フィールド: `credential` と `secret`

## 更新

設定を更新した後、以下のコマンドで反映できます：

```bash
source ~/.zshrc
```

