# Cognitoユーザープール
resource "aws_cognito_user_pool" "main" {
  name = "${var.service}-${var.environment}-user-pool"

  # ユーザーネーム設定（email での認証を許可）
  alias_attributes = ["email"]

  # 自動検証設定
  auto_verified_attributes = ["email"]

  # パスワードポリシー
  password_policy {
    minimum_length    = var.password_minimum_length
    require_lowercase = var.password_require_lowercase
    require_uppercase = var.password_require_uppercase
    require_numbers   = var.password_require_numbers
    require_symbols   = var.password_require_symbols
  }

  # ユーザー属性スキーマ
  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
    mutable             = true
  }

  # メール設定（開発環境用）
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  # ユーザープール作成時の管理者作成権限
  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  # アカウント復旧設定
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  tags = merge(var.tags, {
    Name        = "${var.service}-${var.environment}-user-pool"
    Environment = var.environment
    ManagedBy   = "Terraform"
  })

  # schema変更を無視（Cognitoの制限により一度作成されたschemaは変更不可）
  lifecycle {
    ignore_changes = [schema]
  }
}

# Cognitoユーザープールドメイン
resource "aws_cognito_user_pool_domain" "main" {
  domain       = "${lower(var.service)}-${var.environment}-auth"
  user_pool_id = aws_cognito_user_pool.main.id
}

# Cognitoアプリクライアント（NextJS SPA用）
resource "aws_cognito_user_pool_client" "spa_client" {
  name         = var.app_client_name != "" ? var.app_client_name : "${var.service}-${var.environment}-spa-client"
  user_pool_id = aws_cognito_user_pool.main.id

  # SPA用設定
  generate_secret = false # SPAはクライアントシークレットを使用しない

  # OAuth設定
  callback_urls                        = var.callback_urls
  logout_urls                          = var.logout_urls
  allowed_oauth_flows                  = var.allowed_oauth_flows
  allowed_oauth_scopes                 = var.allowed_oauth_scopes
  allowed_oauth_flows_user_pool_client = true
  supported_identity_providers         = ["COGNITO"]

  # 認証フロー設定
  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH"
  ]

  # トークン設定
  access_token_validity  = 24 # 24時間
  id_token_validity      = 24 # 24時間  
  refresh_token_validity = 30 # 30日

  token_validity_units {
    access_token  = "hours"
    id_token      = "hours"
    refresh_token = "days"
  }

  # トークン取り消し設定
  enable_token_revocation = true

  # SPA用セキュリティ設定
  prevent_user_existence_errors = "ENABLED"
}


