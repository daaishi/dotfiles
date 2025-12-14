#!/bin/bash
# ~/dotfiles/aws/rds-port-forward.sh
# ECSタスクからRDSへのポートフォワーディングを開始するスクリプト

set -euo pipefail

# 設定（環境変数から読み込み、デフォルト値も設定可能）
APP_NAME="${APP_NAME:-}"
ENV_NAME="${ENV_NAME:-}"
SVC_NAME="${SVC_NAME:-}"  # サービス名を直接指定（Copilotの場合は完全なサービス名が必要）
SVC_NAME_SHORT="${SVC_NAME_SHORT:-api}"  # 短いサービス名（例: api）
DB_HOST="${DB_HOST:-}"
LOCAL_PORT="${LOCAL_PORT:-3307}"
CLUSTER_NAME="${CLUSTER_NAME:-}"  # クラスター名を直接指定可能

# 必須パラメータのチェック
if [ -z "$DB_HOST" ]; then
  echo "❌ エラー: DB_HOSTが設定されていません" >&2
  exit 1
fi

# クラスター名が指定されていない場合、APP_NAMEとENV_NAMEから生成
if [ -z "$CLUSTER_NAME" ]; then
  if [ -z "$APP_NAME" ] || [ -z "$ENV_NAME" ]; then
    echo "❌ エラー: CLUSTER_NAMEが指定されていない場合、APP_NAMEとENV_NAMEが必要です" >&2
    echo "" >&2
    echo "使用方法:" >&2
    echo "  方法1: CLUSTER_NAMEを直接指定" >&2
    echo "    export CLUSTER_NAME=\"your-cluster-name\"" >&2
    echo "    export SVC_NAME=\"api\"  # オプション（デフォルト: api）" >&2
    echo "    export DB_HOST=\"your-rds-host.rds.amazonaws.com\"" >&2
    echo "    export LOCAL_PORT=\"3307\"  # オプション（デフォルト: 3307）" >&2
    echo "    $0" >&2
    echo "" >&2
    echo "  方法2: APP_NAMEとENV_NAMEから自動生成（AWS Copilot形式）" >&2
    echo "    export APP_NAME=\"wonder-screen-cms\"" >&2
    echo "    export ENV_NAME=\"prototype\"" >&2
    echo "    export SVC_NAME=\"api\"  # オプション（デフォルト: api）" >&2
    echo "    export DB_HOST=\"your-rds-host.rds.amazonaws.com\"" >&2
    echo "    export LOCAL_PORT=\"3307\"  # オプション（デフォルト: 3307）" >&2
    echo "    $0" >&2
    echo "" >&2
    echo "または、環境変数を直接指定:" >&2
    echo "  CLUSTER_NAME=\"your-cluster\" DB_HOST=\"...\" $0" >&2
    echo "  または" >&2
    echo "  APP_NAME=\"wonder-screen-cms\" ENV_NAME=\"prototype\" DB_HOST=\"...\" $0" >&2
    exit 1
  fi
  # AWS Copilotの命名規則: {app-name}-{env-name}-cluster
  CLUSTER_NAME="$APP_NAME-$ENV_NAME-cluster"
fi

echo "🔍 Connecting to ECS Task..."

# サービス名が指定されていない場合、クラスター内のサービスを検索
if [ -z "$SVC_NAME" ]; then
  if [ -n "$APP_NAME" ] && [ -n "$ENV_NAME" ] && [ -n "$SVC_NAME_SHORT" ]; then
    # Copilotの命名規則でサービス名を検索: {app-name}-{env-name}-{svc-name}-Service-*
    SERVICE_PREFIX="$APP_NAME-$ENV_NAME-$SVC_NAME_SHORT-Service-"
    echo "🔍 サービス名を検索中: $SERVICE_PREFIX*"
    SERVICE_ARN=$(aws ecs list-services \
      --cluster "$CLUSTER_NAME" \
      --query "serviceArns[?contains(@, '$SERVICE_PREFIX')]" \
      --output text | head -n1)
    
    if [ -n "$SERVICE_ARN" ]; then
      # ARNからサービス名を抽出: arn:aws:ecs:region:account:service/cluster-name/service-name
      SVC_NAME="${SERVICE_ARN##*/}"
    fi
    
    if [ -z "$SVC_NAME" ]; then
      echo "❌ エラー: サービスが見つかりませんでした" >&2
      echo "   クラスター: $CLUSTER_NAME" >&2
      echo "   検索パターン: $SERVICE_PREFIX*" >&2
      exit 1
    fi
    echo "✅ サービス名を自動検出: $SVC_NAME"
  else
    echo "❌ エラー: SVC_NAMEが指定されていません" >&2
    echo "   SVC_NAMEを直接指定するか、APP_NAME、ENV_NAME、SVC_NAME_SHORTを設定してください" >&2
    exit 1
  fi
fi

# タスクARNを取得
echo "📋 クラスター: $CLUSTER_NAME"
echo "📋 サービス: $SVC_NAME"
TASK_ARN=$(aws ecs list-tasks \
  --cluster "$CLUSTER_NAME" \
  --service-name "$SVC_NAME" \
  --desired-status RUNNING \
  --query "taskArns[0]" \
  --output text)

if [ -z "$TASK_ARN" ] || [ "$TASK_ARN" = "None" ]; then
  echo "❌ エラー: 実行中のタスクが見つかりませんでした" >&2
  echo "   クラスター: $CLUSTER_NAME" >&2
  echo "   サービス: $SVC_NAME" >&2
  exit 1
fi

TASK_ID=${TASK_ARN##*/}
echo "✅ タスクID: $TASK_ID"

# タスクの詳細を取得してRuntime IDを取得
RUNTIME_ID=$(aws ecs describe-tasks \
  --cluster "$CLUSTER_NAME" \
  --tasks "$TASK_ARN" \
  --query "tasks[0].containers[0].runtimeId" \
  --output text)

if [ -z "$RUNTIME_ID" ] || [ "$RUNTIME_ID" = "None" ]; then
  echo "❌ エラー: Runtime IDを取得できませんでした" >&2
  exit 1
fi

echo "✅ Runtime ID: $RUNTIME_ID"
echo ""
echo "🚀 Starting Port Forwarding to RDS..."
echo "👉 Local: 127.0.0.1:$LOCAL_PORT -> Remote: $DB_HOST:3306"
echo "⚠️  Keep this terminal OPEN (Ctrl+C to stop)"
echo ""

# ポートフォワーディングを開始
aws ssm start-session \
  --target "ecs:${CLUSTER_NAME}_${TASK_ID}_${RUNTIME_ID}" \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters "{\"host\":[\"$DB_HOST\"],\"portNumber\":[\"3306\"],\"localPortNumber\":[\"$LOCAL_PORT\"]}"

