#!/bin/bash
# ~/dotfiles/aws/get-credentials.sh
# 1Password CLIからAWS認証情報を取得して、AWS CLIのcredential_process形式で返す

set -euo pipefail

PROFILE="${AWS_PROFILE:-default}"

# 1Password CLIがインストールされているか確認
if ! command -v op &> /dev/null; then
  echo "Error: 1Password CLI (op) がインストールされていません" >&2
  exit 1
fi

# プロファイル名から1Passwordアイテム名を取得
get_item_name() {
  local profile="$1"
  case "$profile" in
    "default")
      echo "AWS-Default"
      ;;
    "Wonder-Screen-Dev_copilot-user")
      echo "Wonder-Screen-Dev_copilot-user"
      ;;
    *)
      echo "$profile"
      ;;
  esac
}

ITEM_NAME=$(get_item_name "$PROFILE")

# 1Passwordから認証情報を取得
# ボルト: Dev, Private
# フィールド名: "access key id" or "credential", "secret access key" or "secret"
get_credentials() {
  local item_name="$1"
  local vaults=("Dev" "Private")
  local access_key_fields=("access key id" "credential")
  local secret_key_fields=("secret access key" "secret")
  
  for vault in "${vaults[@]}"; do
    for access_field in "${access_key_fields[@]}"; do
      for secret_field in "${secret_key_fields[@]}"; do
        local access_key
        local secret_key
        
        access_key=$(op read "op://${vault}/${item_name}/${access_field}" 2>/dev/null || true)
        secret_key=$(op read "op://${vault}/${item_name}/${secret_field}" 2>/dev/null || true)
        
        if [ -n "$access_key" ] && [ -n "$secret_key" ]; then
          echo "$access_key|$secret_key"
          return 0
        fi
      done
    done
  done
  
  return 1
}

# 認証情報を取得
CREDENTIALS=$(get_credentials "$ITEM_NAME" || true)

if [ -z "$CREDENTIALS" ]; then
  echo "Error: 1Passwordアイテム '${ITEM_NAME}' から認証情報を取得できませんでした" >&2
  echo "" >&2
  echo "確認事項:" >&2
  echo "  1. 1Passwordにサインイン: op signin" >&2
  echo "  2. アイテムが存在するか: Dev/${ITEM_NAME} または Private/${ITEM_NAME}" >&2
  echo "  3. フィールドが存在するか:" >&2
  echo "     - 'access key id' または 'credential' (Access Key ID)" >&2
  echo "     - 'secret access key' または 'secret' (Secret Access Key)" >&2
  exit 1
fi

# 認証情報を分割
ACCESS_KEY_ID="${CREDENTIALS%%|*}"
SECRET_ACCESS_KEY="${CREDENTIALS#*|}"

# AWS CLIのcredential_process形式でJSONを返す
cat <<EOF
{
  "Version": 1,
  "AccessKeyId": "${ACCESS_KEY_ID}",
  "SecretAccessKey": "${SECRET_ACCESS_KEY}"
}
EOF
