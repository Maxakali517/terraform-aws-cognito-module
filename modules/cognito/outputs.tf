# 基本情報
output "region" {
  description = "AWS リージョン"
  value       = var.region
}

output "user_pool_id" {
  description = "CognitoユーザープールID"
  value       = aws_cognito_user_pool.main.id
}

output "user_pool_arn" {
  description = "CognitoユーザープールARN"
  value       = aws_cognito_user_pool.main.arn
}

output "user_pool_endpoint" {
  description = "Cognitoユーザープールエンドポイント"
  value       = aws_cognito_user_pool.main.endpoint
}

# SPAクライアント情報（NextJS用）
output "client_id" {
  description = "CognitoアプリクライアントID（SPA用）"
  value       = aws_cognito_user_pool_client.spa_client.id
}

output "spa_client_name" {
  description = "SPAクライアント名"
  value       = aws_cognito_user_pool_client.spa_client.name
}



# JWT関連情報
output "issuer" {
  description = "JWT Issuer URL（トークン検証用）"
  value       = "https://cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.main.id}"
}

output "jwks_url" {
  description = "JWKS URL（公開鍵情報取得用）"
  value       = "https://cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.main.id}/.well-known/jwks.json"
}

# OAuth関連情報
output "user_pool_domain" {
  description = "Cognitoユーザープールドメイン"
  value       = aws_cognito_user_pool_domain.main.domain
}

output "hosted_ui_url" {
  description = "Cognito Hosted UI ベースURL"
  value       = "https://${aws_cognito_user_pool_domain.main.domain}.auth.${var.region}.amazoncognito.com"
}

output "hosted_ui_login_url" {
  description = "Cognito Hosted UI ログインURL（完全版）"
  value       = "https://${aws_cognito_user_pool_domain.main.domain}.auth.${var.region}.amazoncognito.com/login?client_id=${aws_cognito_user_pool_client.spa_client.id}&response_type=code&scope=openid+email+profile&redirect_uri=${urlencode(var.callback_urls[0])}"
}

# フロントエンド設定用（環境変数として使用）
output "frontend_config" {
  description = "フロントエンド（NextJS）用設定値"
  value = {
    region      = var.region
    userPoolId  = aws_cognito_user_pool.main.id
    clientId    = aws_cognito_user_pool_client.spa_client.id
    domain      = aws_cognito_user_pool_domain.main.domain
    redirectUri = length(var.callback_urls) > 0 ? var.callback_urls[0] : null
    logoutUri   = length(var.logout_urls) > 0 ? var.logout_urls[0] : null
  }
}

# バックエンド設定用（環境変数として使用）
output "backend_config" {
  description = "バックエンド（FastAPI）用設定値"
  value = {
    region     = var.region
    userPoolId = aws_cognito_user_pool.main.id
    clientId   = aws_cognito_user_pool_client.spa_client.id
    issuer     = "https://cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.main.id}"
    jwksUrl    = "https://cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.main.id}/.well-known/jwks.json"
  }
}

# すべての設定情報（デバッグ用）
output "cognito_config" {
  description = "Cognito設定の完全な情報"
  value = {
    region           = var.region
    user_pool_id     = aws_cognito_user_pool.main.id
    user_pool_arn    = aws_cognito_user_pool.main.arn
    client_id        = aws_cognito_user_pool_client.spa_client.id
    domain          = aws_cognito_user_pool_domain.main.domain
    hosted_ui_url   = "https://${aws_cognito_user_pool_domain.main.domain}.auth.${var.region}.amazoncognito.com"
    issuer          = "https://cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.main.id}"
    jwks_url        = "https://cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.main.id}/.well-known/jwks.json"
    callback_urls   = var.callback_urls
    logout_urls     = var.logout_urls
  }
}
