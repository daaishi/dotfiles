#!/bin/bash
# ~/dotfiles/aws/rds-port-forward-wonder-screen-cms-prototype.sh
# Wonder Screen CMS (prototype環境) のRDSポートフォワーディングスクリプト

set -euo pipefail

# 環境設定
export CLUSTER_NAME="wonder-screen-cms-prototype-Cluster-mpVsMc5J6qS5"
export SVC_NAME="wonder-screen-cms-prototype-api-Service-Y9yEiJkxkFpf"
export DB_HOST="wonder-screen-cms-prototyp-wonderscreendbdbcluster-8q5eczwjeopk.cluster-cngacauc2azh.ap-northeast-1.rds.amazonaws.com"
export LOCAL_PORT="3307"

# このスクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 汎用スクリプトを実行
exec "$SCRIPT_DIR/rds-port-forward.sh"

