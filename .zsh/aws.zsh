# AWS設定
export AWS_SHARED_CREDENTIALS_FILE="$HOME/.aws/credentials"
export AWS_CONFIG_FILE="$HOME/.aws/config"

# デフォルトでSSOプロファイルを使用（明示的に設定）
# 新しいターミナルでは常に ws-proto を使用
if [ -z "$AWS_PROFILE" ] || [[ "$AWS_PROFILE" == *"copilot"* ]] || [[ "$AWS_PROFILE" == *"Wonder-Screen-Dev"* ]]; then
  export AWS_PROFILE="ws-proto"
fi

# AWSプロファイルをプロンプトに表示する関数
aws_prompt_info() {
  local profile="${AWS_PROFILE:-default}"
  if [ -n "$profile" ]; then
    echo "%{$fg_bold[yellow]%}[AWS: $profile]%{$reset_color%} "
  fi
}

# AWSエイリアス
alias aws-profile='aws configure list-profiles'
alias aws-whoami='aws sts get-caller-identity'

# AWS環境情報を取得する関数
aws-env() {
  local profile="${AWS_PROFILE:-default}"
  
  echo "🔍 AWS環境情報"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  # プロファイル情報
  echo "📋 プロファイル: $profile"
  
  # アカウント情報
  echo ""
  echo "💳 アカウント情報:"
  if aws sts get-caller-identity &> /dev/null; then
    aws sts get-caller-identity --output table 2>/dev/null || aws sts get-caller-identity
  else
    echo "  ❌ 認証情報が無効です。ログインしてください: aws sso login"
  fi
  
  # リージョン情報
  echo ""
  echo "🌍 リージョン設定:"
  local region=$(aws configure get region --profile "$profile" 2>/dev/null || echo "未設定")
  echo "  Region: $region"
  
  # SSO情報
  echo ""
  echo "🔐 SSO設定:"
  local sso_session=$(aws configure get sso_session --profile "$profile" 2>/dev/null || echo "なし")
  local sso_account=$(aws configure get sso_account_id --profile "$profile" 2>/dev/null || echo "なし")
  local sso_role=$(aws configure get sso_role_name --profile "$profile" 2>/dev/null || echo "なし")
  
  if [ "$sso_session" != "なし" ]; then
    echo "  SSO Session: $sso_session"
    echo "  Account ID: $sso_account"
    echo "  Role: $sso_role"
  else
    echo "  SSO設定なし（Static Credentials使用）"
  fi
  
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# AWS構築環境・リソースを確認する関数
aws-resources() {
  local profile="${AWS_PROFILE:-default}"
  local region=$(aws configure get region --profile "$profile" 2>/dev/null || echo "ap-northeast-1")
  
  echo "🏗️  AWS構築環境・リソース一覧"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "プロファイル: $profile | リージョン: $region"
  echo ""
  
  # 認証確認
  if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ 認証情報が無効です。ログインしてください: aws sso login"
    return 1
  fi
  
  # ECSクラスター一覧
  echo "📦 ECSクラスター:"
  # すべてのクラスターを取得（ページネーション対応）
  local cluster_output=$(aws ecs list-clusters --region "$region" --no-paginate --query "clusterArns" --output text 2>/dev/null)
  
  # 出力がJSON形式の場合（jqが利用可能な場合）
  if command -v jq &> /dev/null && [[ "$cluster_output" == *"["* ]]; then
    local clusters=$(echo "$cluster_output" | jq -r '.[]' 2>/dev/null)
  else
    local clusters="$cluster_output"
  fi
  
  if [ -n "$clusters" ] && [[ "$clusters" != "None" ]] && [[ "$clusters" != "null" ]]; then
    # zshでスペース区切りの文字列をループするために、一時的にshwordsplitを有効化
    local old_shwordsplit=$(setopt | grep -q shwordsplit && echo "on" || echo "off")
    setopt shwordsplit
    
    # クラスターARNを処理（改行をスペースに変換してからループ）
    local clusters_normalized=$(echo "$clusters" | tr '\n' ' ')
    
    # スペース区切りの各クラスターを処理
    for cluster in $clusters_normalized; do
      # 空の要素をスキップ
      if [ -z "$cluster" ] || [[ "$cluster" == "null" ]]; then
        continue
      fi
      
      local cluster_name=$(basename "$cluster")
      echo "  - $cluster_name"
      
      # 各クラスターのサービス一覧（ページネーション対応）
      local service_output=$(aws ecs list-services --cluster "$cluster_name" --region "$region" --no-paginate --query "serviceArns" --output text 2>/dev/null)
      
      # サービス出力の処理
      local services
      if command -v jq &> /dev/null && [[ "$service_output" == *"["* ]]; then
        services=$(echo "$service_output" | jq -r '.[]' 2>/dev/null)
      else
        services="$service_output"
      fi
      
      if [ -n "$services" ] && [[ "$services" != "None" ]] && [[ "$services" != "null" ]]; then
        # サービスを処理（改行をスペースに変換）
        local services_normalized=$(echo "$services" | tr '\n' ' ')
        for service in $services_normalized; do
          if [ -n "$service" ] && [[ "$service" != "null" ]]; then
            local service_name=$(basename "$service")
            echo "    └─ $service_name"
          fi
        done
      fi
    done
    
    # shwordsplitを元に戻す
    if [[ "$old_shwordsplit" == "off" ]]; then
      unsetopt shwordsplit
    fi
  else
    echo "  (なし)"
  fi
  echo ""
  
  # RDSインスタンス一覧
  echo "🗄️  RDSインスタンス:"
  local rds_instances=$(aws rds describe-db-instances --region "$region" --query "DBInstances[*].[DBInstanceIdentifier,DBInstanceStatus,Engine,Endpoint.Address]" --output text 2>/dev/null)
  if [ -n "$rds_instances" ] && [[ "$rds_instances" != "None" ]]; then
    echo "$rds_instances" | while read -r line; do
      if [ -n "$line" ]; then
        echo "  - $line"
      fi
    done
  else
    echo "  (なし)"
  fi
  echo ""
  
  # RDSクラスター一覧
  echo "🗄️  RDSクラスター:"
  local rds_clusters=$(aws rds describe-db-clusters --region "$region" --query "DBClusters[*].[DBClusterIdentifier,Status,Engine,Endpoint]" --output text 2>/dev/null)
  if [ -n "$rds_clusters" ] && [[ "$rds_clusters" != "None" ]]; then
    echo "$rds_clusters" | while read -r line; do
      if [ -n "$line" ]; then
        echo "  - $line"
      fi
    done
  else
    echo "  (なし)"
  fi
  echo ""
  
  # S3バケット一覧
  echo "🪣 S3バケット:"
  # S3はリージョンに依存しないが、バケットの場所情報を取得するためにus-east-1を使用
  local s3_buckets=$(aws s3api list-buckets --query "Buckets[*].[Name,CreationDate]" --output text 2>/dev/null)
  if [ -n "$s3_buckets" ] && [[ "$s3_buckets" != "None" ]]; then
    echo "$s3_buckets" | while read -r line; do
      if [ -n "$line" ]; then
        local bucket_name=$(echo "$line" | awk '{print $1}')
        local creation_date=$(echo "$line" | awk '{print $2" "$3}')
        
        # バケットのリージョンを取得
        local bucket_region=$(aws s3api get-bucket-location --bucket "$bucket_name" --query "LocationConstraint" --output text 2>/dev/null)
        # us-east-1の場合はLocationConstraintがNoneまたは空になる
        if [ -z "$bucket_region" ] || [[ "$bucket_region" == "None" ]]; then
          bucket_region="us-east-1"
        fi
        
        echo "  - $bucket_name"
        echo "    └─ Region: $bucket_region, Created: $creation_date"
      fi
    done
  else
    echo "  (なし)"
  fi
  echo ""
  
  # Lambda関数一覧
  echo "⚡️  Lambda関数:"
  local lambda_functions=$(aws lambda list-functions --region "$region" --query "Functions[*].[FunctionName,Runtime,LastModified]" --output text 2>/dev/null)
  if [ -n "$lambda_functions" ] && [[ "$lambda_functions" != "None" ]]; then
    echo "$lambda_functions" | while read -r line; do
      if [ -n "$line" ]; then
        local func_name=$(echo "$line" | awk '{print $1}')
        local func_runtime=$(echo "$line" | awk '{print $2}')
        local func_modified=$(echo "$line" | awk '{print $3" "$4}')
        echo "  - $func_name ($func_runtime)"
        if [ -n "$func_modified" ] && [ "$func_modified" != "None" ]; then
          echo "    └─ Last Modified: $func_modified"
        fi
      fi
    done
  else
    echo "  (なし)"
  fi
  echo ""
  
  # API Gateway一覧
  echo "🌐 API Gateway:"
  local api_gateways=$(aws apigateway get-rest-apis --region "$region" --query "items[*].[name,id,createdDate]" --output text 2>/dev/null)
  if [ -n "$api_gateways" ] && [[ "$api_gateways" != "None" ]]; then
    echo "$api_gateways" | while read -r line; do
      if [ -n "$line" ]; then
        local api_name=$(echo "$line" | awk '{print $1}')
        local api_id=$(echo "$line" | awk '{print $2}')
        local api_created=$(echo "$line" | awk '{print $3}')
        echo "  - $api_name (ID: $api_id)"
        if [ -n "$api_created" ] && [ "$api_created" != "None" ]; then
          echo "    └─ Created: $api_created"
        fi
      fi
    done
  else
    echo "  (なし)"
  fi
  echo ""
  
  # CloudFrontディストリビューション一覧
  echo "☁️  CloudFront:"
  local cloudfront_dists=$(aws cloudfront list-distributions --query "DistributionList.Items[*].[Id,DomainName,Status,Comment]" --output text 2>/dev/null)
  if [ -n "$cloudfront_dists" ] && [[ "$cloudfront_dists" != "None" ]]; then
    echo "$cloudfront_dists" | while read -r line; do
      if [ -n "$line" ]; then
        local dist_id=$(echo "$line" | awk '{print $1}')
        local dist_domain=$(echo "$line" | awk '{print $2}')
        local dist_status=$(echo "$line" | awk '{print $3}')
        local dist_comment=$(echo "$line" | awk '{print $4}')
        echo "  - $dist_id ($dist_status)"
        if [ -n "$dist_domain" ] && [ "$dist_domain" != "None" ]; then
          echo "    └─ Domain: $dist_domain"
        fi
        if [ -n "$dist_comment" ] && [ "$dist_comment" != "None" ]; then
          echo "    └─ Comment: $dist_comment"
        fi
      fi
    done
  else
    echo "  (なし)"
  fi
  echo ""
  
  # EC2インスタンス一覧
  echo "🖥️  EC2インスタンス:"
  local ec2_instances=$(aws ec2 describe-instances --region "$region" --query "Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,Tags[?Key=='Name'].Value|[0]]" --output text 2>/dev/null)
  if [ -n "$ec2_instances" ] && [[ "$ec2_instances" != "None" ]]; then
    echo "$ec2_instances" | while read -r line; do
      if [ -n "$line" ]; then
        local instance_id=$(echo "$line" | awk '{print $1}')
        local instance_state=$(echo "$line" | awk '{print $2}')
        local instance_type=$(echo "$line" | awk '{print $3}')
        local instance_name=$(echo "$line" | awk '{print $4}')
        if [ -n "$instance_name" ] && [ "$instance_name" != "None" ]; then
          echo "  - $instance_name ($instance_id, $instance_type, $instance_state)"
        else
          echo "  - $instance_id ($instance_type, $instance_state)"
        fi
      fi
    done
  else
    echo "  (なし)"
  fi
  echo ""
  
  # DynamoDBテーブル一覧
  echo "📊 DynamoDB:"
  local dynamodb_tables=$(aws dynamodb list-tables --region "$region" --query "TableNames" --output text 2>/dev/null)
  if [ -n "$dynamodb_tables" ] && [[ "$dynamodb_tables" != "None" ]]; then
    local old_shwordsplit=$(setopt | grep -q shwordsplit && echo "on" || echo "off")
    setopt shwordsplit
    local tables_normalized=$(echo "$dynamodb_tables" | tr '\n' ' ')
    for table in $tables_normalized; do
      if [ -n "$table" ] && [[ "$table" != "null" ]]; then
        # テーブルの詳細情報を取得
        local table_info=$(aws dynamodb describe-table --table-name "$table" --region "$region" --query "Table.[TableStatus,ItemCount]" --output text 2>/dev/null)
        if [ -n "$table_info" ]; then
          local table_status=$(echo "$table_info" | awk '{print $1}')
          local item_count=$(echo "$table_info" | awk '{print $2}')
          echo "  - $table ($table_status, Items: $item_count)"
        else
          echo "  - $table"
        fi
      fi
    done
    if [[ "$old_shwordsplit" == "off" ]]; then
      unsetopt shwordsplit
    fi
  else
    echo "  (なし)"
  fi
  echo ""
  
  # ElastiCacheクラスター一覧
  echo "💾 ElastiCache:"
  local elasticache_clusters=$(aws elasticache describe-cache-clusters --region "$region" --query "CacheClusters[*].[CacheClusterId,Engine,CacheNodeType,CacheClusterStatus]" --output text 2>/dev/null)
  if [ -n "$elasticache_clusters" ] && [[ "$elasticache_clusters" != "None" ]]; then
    echo "$elasticache_clusters" | while read -r line; do
      if [ -n "$line" ]; then
        local cache_id=$(echo "$line" | awk '{print $1}')
        local cache_engine=$(echo "$line" | awk '{print $2}')
        local cache_type=$(echo "$line" | awk '{print $3}')
        local cache_status=$(echo "$line" | awk '{print $4}')
        echo "  - $cache_id ($cache_engine, $cache_type, $cache_status)"
      fi
    done
  else
    echo "  (なし)"
  fi
  echo ""
  
  # ロードバランサー一覧
  echo "⚖️  ロードバランサー:"
  
  # Application Load Balancer (ALB)
  local alb_output=$(aws elbv2 describe-load-balancers --region "$region" --query "LoadBalancers[?Type=='application'].[LoadBalancerName,DNSName,State.Code,Scheme]" --output text 2>/dev/null)
  if [ -n "$alb_output" ] && [[ "$alb_output" != "None" ]]; then
    echo "  Application Load Balancer (ALB):"
    echo "$alb_output" | while read -r line; do
      if [ -n "$line" ]; then
        local alb_name=$(echo "$line" | awk '{print $1}')
        local alb_dns=$(echo "$line" | awk '{print $2}')
        local alb_state=$(echo "$line" | awk '{print $3}')
        local alb_scheme=$(echo "$line" | awk '{print $4}')
        echo "    - $alb_name ($alb_state, $alb_scheme)"
        if [ -n "$alb_dns" ] && [ "$alb_dns" != "None" ]; then
          echo "      └─ DNS: $alb_dns"
        fi
      fi
    done
  fi
  
  # Network Load Balancer (NLB)
  local nlb_output=$(aws elbv2 describe-load-balancers --region "$region" --query "LoadBalancers[?Type=='network'].[LoadBalancerName,DNSName,State.Code,Scheme]" --output text 2>/dev/null)
  if [ -n "$nlb_output" ] && [[ "$nlb_output" != "None" ]]; then
    echo "  Network Load Balancer (NLB):"
    echo "$nlb_output" | while read -r line; do
      if [ -n "$line" ]; then
        local nlb_name=$(echo "$line" | awk '{print $1}')
        local nlb_dns=$(echo "$line" | awk '{print $2}')
        local nlb_state=$(echo "$line" | awk '{print $3}')
        local nlb_scheme=$(echo "$line" | awk '{print $4}')
        echo "    - $nlb_name ($nlb_state, $nlb_scheme)"
        if [ -n "$nlb_dns" ] && [ "$nlb_dns" != "None" ]; then
          echo "      └─ DNS: $nlb_dns"
        fi
      fi
    done
  fi
  
  # Classic Load Balancer (CLB) - レガシー
  local clb_output=$(aws elb describe-load-balancers --region "$region" --query "LoadBalancerDescriptions[*].[LoadBalancerName,DNSName,LoadBalancerName]" --output text 2>/dev/null)
  if [ -n "$clb_output" ] && [[ "$clb_output" != "None" ]]; then
    echo "  Classic Load Balancer (CLB):"
    echo "$clb_output" | while read -r line; do
      if [ -n "$line" ]; then
        local clb_name=$(echo "$line" | awk '{print $1}')
        local clb_dns=$(echo "$line" | awk '{print $2}')
        echo "    - $clb_name"
        if [ -n "$clb_dns" ] && [ "$clb_dns" != "None" ]; then
          echo "      └─ DNS: $clb_dns"
        fi
      fi
    done
  fi
  
  # ロードバランサーが1つもない場合
  if [[ -z "$alb_output" || "$alb_output" == "None" ]] && [[ -z "$nlb_output" || "$nlb_output" == "None" ]] && [[ -z "$clb_output" || "$clb_output" == "None" ]]; then
    echo "  (なし)"
  fi
  echo ""
  
  # VPC一覧
  echo "🌐 VPC:"
  local vpcs=$(aws ec2 describe-vpcs --region "$region" --query "Vpcs[*].[VpcId,Tags[?Key=='Name'].Value|[0],CidrBlock]" --output text 2>/dev/null)
  if [ -n "$vpcs" ] && [[ "$vpcs" != "None" ]]; then
    echo "$vpcs" | while read -r line; do
      if [ -n "$line" ]; then
        echo "  - $line"
      fi
    done
  else
    echo "  (なし)"
  fi
  echo ""
  
  # Copilotアプリケーション（Copilot CLIがインストールされている場合）
  echo "🚀 Copilotアプリケーション:"
  if command -v copilot &> /dev/null; then
    # Copilot CLIのバージョン確認
    local copilot_version=$(copilot --version 2>/dev/null | head -n1)
    
    # アプリケーション一覧を取得
    local copilot_output=$(copilot app ls 2>&1)
    local copilot_exit_code=$?
    
    if [ $copilot_exit_code -eq 0 ]; then
      # 出力からアプリケーション名を抽出
      # ヘッダー行（"Name"など）をスキップし、空行やエラーメッセージを除外
      local copilot_apps=$(echo "$copilot_output" | grep -v "^Name" | grep -v "^---" | awk '{print $1}' | grep -v "^$" | grep -v "^✘" | grep -v "^Error")
      
      if [ -n "$copilot_apps" ]; then
        for app in $copilot_apps; do
          # アプリケーション名が有効か確認（空でない、エラーメッセージでない）
          if [[ "$app" =~ ^[a-zA-Z0-9-]+$ ]]; then
            echo "  - $app"
            # 各アプリの環境一覧
            local env_output=$(copilot env ls --app "$app" 2>&1)
            if [ $? -eq 0 ]; then
              local envs=$(echo "$env_output" | grep -v "^Name" | grep -v "^---" | awk '{print $1}' | grep -v "^$" | grep -v "^✘" | grep -v "^Error")
              if [ -n "$envs" ]; then
                for env in $envs; do
                  if [[ "$env" =~ ^[a-zA-Z0-9-]+$ ]]; then
                    echo "    └─ $env"
                  fi
                done
              fi
            fi
          fi
        done
      else
        echo "  (アプリケーションが見つかりません)"
        echo "  💡 ヒント: AWS認証を確認してください (aws-check-auth)"
      fi
    else
      echo "  ⚠️  Copilot CLIの実行に失敗しました"
      echo "  エラー: $(echo "$copilot_output" | head -n1)"
      echo "  💡 ヒント: AWS認証を確認してください (aws-check-auth)"
    fi
  else
    echo "  (Copilot CLIがインストールされていません)"
    echo "  💡 インストール: brew install aws-copilot-cli"
  fi
  echo ""
  
  # AWS Amplifyアプリケーション
  echo "⚡️  AWS Amplifyアプリケーション:"
  local amplify_apps=$(aws amplify list-apps --region "$region" --query "apps[*].[name,appId,defaultDomain]" --output text 2>/dev/null)
  if [ -n "$amplify_apps" ] && [[ "$amplify_apps" != "None" ]]; then
    echo "$amplify_apps" | while read -r line; do
      if [ -n "$line" ]; then
        # アプリ名、ID、ドメインを表示
        local app_name=$(echo "$line" | awk '{print $1}')
        local app_id=$(echo "$line" | awk '{print $2}')
        local app_domain=$(echo "$line" | awk '{print $3}')
        echo "  - $app_name (ID: $app_id)"
        if [ -n "$app_domain" ] && [ "$app_domain" != "None" ]; then
          echo "    └─ Domain: $app_domain"
        fi
        
        # 各アプリのブランチ一覧
        local branches=$(aws amplify list-branches --app-id "$app_id" --region "$region" --query "branches[*].[branchName,stage]" --output text 2>/dev/null)
        if [ -n "$branches" ] && [[ "$branches" != "None" ]]; then
          echo "$branches" | while read -r branch_line; do
            if [ -n "$branch_line" ]; then
              local branch_name=$(echo "$branch_line" | awk '{print $1}')
              local branch_stage=$(echo "$branch_line" | awk '{print $2}')
              if [ -n "$branch_name" ] && [ "$branch_name" != "None" ]; then
                echo "    └─ Branch: $branch_name ($branch_stage)"
              fi
            fi
          done
        fi
      fi
    done
  else
    echo "  (なし)"
  fi
  echo ""
  
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "💡 ヒント: 特定のリソースの詳細を見るには、AWS CLIコマンドを直接使用してください"
}

# AWS SSO認証チェック関数
aws-check-auth() {
  local profile="${AWS_PROFILE:-default}"
  
  echo "🔍 AWS SSO認証状態の確認 (プロファイル: $profile)"
  echo ""

  # SSOセッションの状態確認
  if aws sts get-caller-identity &> /dev/null; then
    echo "✅ AWS認証情報が有効です"
    aws sts get-caller-identity
    return 0
  else
    echo "❌ AWS認証情報が無効、または期限切れです"
    echo ""
    echo "SSOログインを試みます..."
    echo "実行コマンド: aws sso login --profile $profile"
    
    if aws sso login --profile "$profile"; then
      echo ""
      echo "✅ SSOログインに成功しました"
      aws sts get-caller-identity
      return 0
    else
      echo ""
      echo "❌ SSOログインに失敗しました"
      return 1
    fi
  fi
}

# AWSプロファイル切り替え関数（aws-switchコマンド）
aws-switch() {
  local profiles
  local selected_profile
  local profile_count

  # プロファイル一覧を取得
  profiles=($(aws configure list-profiles 2>/dev/null))
  
  if [ ${#profiles[@]} -eq 0 ]; then
    echo "❌ プロファイルが見つかりません"
    return 1
  fi

  # 引数が指定されている場合
  if [ -n "$1" ]; then
    # プロファイルが存在するか確認
    if printf '%s\n' "${profiles[@]}" | grep -q "^$1$"; then
      export AWS_PROFILE="$1"
      echo "✅ AWSプロファイルを '$1' に切り替えました"
      echo ""
      # 認証情報の確認
      aws-check-auth
      return 0
    else
      echo "❌ プロファイル '$1' が見つかりません"
      echo ""
      echo "利用可能なプロファイル:"
      printf '  - %s\n' "${profiles[@]}"
      return 1
    fi
  fi

  # 対話的にプロファイルを選択
  echo "利用可能なAWSプロファイル:"
  echo ""
  profile_count=1
  for profile in "${profiles[@]}"; do
    if [ "$profile" = "$AWS_PROFILE" ]; then
      echo "  [$profile_count] $profile (現在選択中) ⭐"
    else
      echo "  [$profile_count] $profile"
    fi
    ((profile_count++))
  done
  echo ""
  echo -n "プロファイルを選択してください [1-${#profiles[@]}]: "
  read -r selection

  # 選択が有効か確認
  if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt ${#profiles[@]} ]; then
    echo "❌ 無効な選択です"
    return 1
  fi

  selected_profile="${profiles[$selection]}"
  export AWS_PROFILE="$selected_profile"
  echo ""
  echo "✅ AWSプロファイルを '$selected_profile' に切り替えました"
  echo ""
  # 認証情報の確認
  aws-check-auth
}

# 後方互換性のため、aws-profile-setも残す
aws-profile-set() {
  aws-switch "$@"
}
