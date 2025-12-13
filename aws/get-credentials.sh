#!/bin/bash
# ~/dotfiles/aws/get-credentials.sh
# 1Password CLIからAWS認証情報を取得して、AWS CLIのcredential_process形式で返す

PROFILE="${AWS_PROFILE:-default}"

# 1Password CLIがインストールされているか確認
if ! command -v op &> /dev/null; then
  echo "Error: 1Password CLI (op) がインストールされていません" >&2
  exit 1
fi

# 1Passwordにサインインしているか確認
if ! op whoami &> /dev/null; then
  echo "Error: 1Passwordにサインインしてください。'op signin' を実行してください" >&2
  exit 1
fi

# プロファイルに応じた1Passwordアイテム名を決定
case "$PROFILE" in
  "default")
    ITEM_NAME="AWS-Default"
    ;;
  "Wonder-Screen-Dev_copilot-user")
    ITEM_NAME="AWS-Wonder-Screen-Dev_copilot-user"
    ;;
  *)
    # プロファイル名から自動的にアイテム名を生成
    # 例: "my-profile" -> "AWS-my-profile"
    ITEM_NAME="AWS-${PROFILE}"
    ;;
esac

# 1Passwordから認証情報を取得
ACCESS_KEY_ID=$(op read "op://Dev/${ITEM_NAME}/access key id" 2>/dev/null)
SECRET_ACCESS_KEY=$(op read "op://Dev/${ITEM_NAME}/secret access key" 2>/dev/null)

if [ -z "$ACCESS_KEY_ID" ] || [ -z "$SECRET_ACCESS_KEY" ]; then
  echo "Error: 1Passwordアイテム '${ITEM_NAME}' から認証情報を取得できませんでした" >&2
  echo "1Passwordに以下のアイテムが存在することを確認してください:" >&2
  echo "  - Private/${ITEM_NAME}" >&2
  echo "  - credential フィールド (Access Key ID)" >&2
  echo "  - secret フィールド (Secret Access Key)" >&2
  exit 1
fi

# AWS CLIのcredential_process形式でJSONを返す
cat <<EOF
{
  "Version": 1,
  "AccessKeyId": "${ACCESS_KEY_ID}",
  "SecretAccessKey": "${SECRET_ACCESS_KEY}"
}
EOF

