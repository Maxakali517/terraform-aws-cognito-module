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
  description = "Cognito Hosted UI ログインURL"
  value       = module.cognito.hosted_ui_login_url
}
