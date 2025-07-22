# Cognitoモジュール呼び出し
module "cognito" {
  source = "./modules/cognito"

  # 基本設定
  service     = var.service
  environment = var.environment
  region      = var.aws_region

  # NextJS SPA用URL設定
  callback_urls = var.callback_urls
  logout_urls   = var.logout_urls

  # パスワードポリシー
  password_minimum_length    = 8
  password_require_lowercase = true
  password_require_uppercase = true
  password_require_numbers   = true
  password_require_symbols   = false

  # OAuth設定
  allowed_oauth_flows  = ["code"]
  allowed_oauth_scopes = ["openid", "email", "profile"]

}
