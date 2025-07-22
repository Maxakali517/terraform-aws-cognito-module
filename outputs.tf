# 出力（フロントエンド・バックエンドチーム向け）
output "cognito_region" {
  description = "AWS リージョン"
  value       = module.cognito.region
}

output "cognito_user_pool_id" {
  description = "CognitoユーザープールID"
  value       = module.cognito.user_pool_id
}

output "cognito_client_id" {
  description = "CognitoアプリクライアントID（SPA用）"
  value       = module.cognito.client_id
}

output "cognito_issuer" {
  description = "JWT Issuer URL"
  value       = module.cognito.issuer
}

output "cognito_jwks_url" {
  description = "JWKS URL"
  value       = module.cognito.jwks_url
}

output "cognito_hosted_ui_url" {
  description = "Cognito Hosted UI ベースURL"
  value       = module.cognito.hosted_ui_url
}

output "cognito_hosted_ui_login_url" {
  description = "Cognito Hosted UI ログインURL（すぐにアクセス可能）"
  value       = module.cognito.hosted_ui_login_url
}

# フロントエンドチーム向け設定
output "frontend_env_vars" {
  description = "フロントエンド（NextJS）の環境変数設定"
  value = {
    NEXT_PUBLIC_AWS_REGION          = module.cognito.region
    NEXT_PUBLIC_USER_POOL_ID        = module.cognito.user_pool_id
    NEXT_PUBLIC_USER_POOL_CLIENT_ID = module.cognito.client_id
    NEXT_PUBLIC_OAUTH_DOMAIN        = module.cognito.user_pool_domain
    NEXT_PUBLIC_REDIRECT_URI        = length(var.callback_urls) > 0 ? var.callback_urls[0] : ""
    NEXT_PUBLIC_LOGOUT_URI          = length(var.logout_urls) > 0 ? var.logout_urls[0] : ""
  }
}

# バックエンドチーム向け設定
output "backend_env_vars" {
  description = "バックエンド（FastAPI）の環境変数設定"
  value = {
    AWS_REGION   = module.cognito.region
    USER_POOL_ID = module.cognito.user_pool_id
    CLIENT_ID    = module.cognito.client_id
    ISSUER       = module.cognito.issuer
    JWKS_URL     = module.cognito.jwks_url
  }
} 