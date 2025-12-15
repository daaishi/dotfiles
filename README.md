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
- `aws/rds-port-forward.sh` - ECSタスクからRDSへのポートフォワーディングスクリプト（汎用）
- `aws/rds-port-forward-wonder-screen-cms-prototype.sh` - Wonder Screen CMS (prototype環境) 用のポートフォワーディングスクリプト
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
```

### SSO認証 (IAM Identity Center)

AWS認証はSSO (IAM Identity Center) を使用します。

#### セットアップ

`aws/config` にSSO設定が含まれています。初回利用時やセッション切れの際はログインが必要です。

#### ログイン

```bash
aws sso login
```

ブラウザが起動し、許可を求められます。「Allow」をクリックしてください。

#### 認証確認

```bash
aws sts get-caller-identity
```

### プロファイル管理

デフォルトで `wonder-screen-sso` プロファイルが使用されます。

#### 利用可能なコマンド

- `aws-switch` - 対話的にプロファイルを切り替え
- `aws-switch <プロファイル名>` - 指定したプロファイルに切り替え
- `aws-profile` - 利用可能なプロファイル一覧を表示
- `aws-whoami` - 現在のAWSアカウント情報を表示
- `aws-check-auth` - 認証状態を確認し、必要ならログインを促します

#### プロファイルの切り替え

```bash
# 対話的にプロファイルを選択
aws-switch

# 直接プロファイルを指定
aws-switch wonder-screen-sso
aws-switch default
```

#### 新しいプロファイルの追加

1. `aws/config`にプロファイルを追加:
   ```ini
   [profile 新しいプロファイル名]
   sso_session = ws-sso
   sso_account_id = <アカウントID>
   sso_role_name = <ロール名>
   region = ap-northeast-1
   output = json
   ```

### RDSポートフォワーディング

ECSタスク経由でRDSデータベースにポートフォワーディング接続する場合、`aws/rds-port-forward.sh`を使用できます。

#### 使用方法

##### 方法1: 環境別スクリプトを使用（推奨）

環境ごとに設定済みのスクリプトを使用する場合：

```bash
# Wonder Screen CMS (prototype環境)
~/dotfiles/aws/rds-port-forward-wonder-screen-cms-prototype.sh
```

環境別スクリプトは、環境変数の設定が含まれているため、そのまま実行できます。

##### 方法2: 汎用スクリプトを使用

環境変数を設定して汎用スクリプトを実行します：

```bash
export APP_NAME="wonder-screen-cms"
export ENV_NAME="prototype"
export SVC_NAME="api"  # オプション（デフォルト: api）
export DB_HOST="your-rds-host.cluster-xxxxx.ap-northeast-1.rds.amazonaws.com"
export LOCAL_PORT="3307"  # オプション（デフォルト: 3307）

~/dotfiles/aws/rds-port-forward.sh
```

または、環境変数を直接指定：

```bash
APP_NAME="wonder-screen-cms" \
ENV_NAME="prototype" \
DB_HOST="your-rds-host.cluster-xxxxx.ap-northeast-1.rds.amazonaws.com" \
~/dotfiles/aws/rds-port-forward.sh
```

##### 新しい環境用スクリプトの作成

新しい環境用のスクリプトを作成する場合、`aws/rds-port-forward-wonder-screen-cms-prototype.sh`を参考にしてください：

```bash
#!/bin/bash
# ~/dotfiles/aws/rds-port-forward-<app-name>-<env-name>.sh

set -euo pipefail

export APP_NAME="your-app-name"
export ENV_NAME="your-env-name"
export SVC_NAME="api"  # 必要に応じて変更
export DB_HOST="your-rds-host.cluster-xxxxx.ap-northeast-1.rds.amazonaws.com"
export LOCAL_PORT="3307"  # 必要に応じて変更

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/rds-port-forward.sh"
```

接続後、ローカルの`127.0.0.1:3307`（または指定したポート）でRDSデータベースにアクセスできます。

**注意**: ポートフォワーディングセッションは、ターミナルを開いている間のみ有効です。終了する場合は`Ctrl+C`を押してください。

## 更新

設定を更新した後、以下のコマンドで反映できます：

```bash
source ~/.zshrc
```

