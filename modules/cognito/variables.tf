variable "service" {
  description = "サービス名（命名プレフィックスに使用）"
  type        = string
}

variable "environment" {
  description = "環境名（命名プレフィックスに使用）"
  type        = string
}

variable "region" {
  description = "AWS リージョン"
  type        = string
}

variable "password_minimum_length" {
  description = "パスワードの最小文字数"
  type        = number
  default     = 8
}

variable "password_require_lowercase" {
  description = "パスワードに小文字を必須とするか"
  type        = bool
  default     = true
}

variable "password_require_uppercase" {
  description = "パスワードに大文字を必須とするか"
  type        = bool
  default     = true
}

variable "password_require_numbers" {
  description = "パスワードに数字を必須とするか"
  type        = bool
  default     = true
}

variable "password_require_symbols" {
  description = "パスワードに記号を必須とするか"
  type        = bool
  default     = false
}

variable "app_client_name" {
  description = "Cognitoアプリクライアント名"
  type        = string
  default     = ""
}

variable "callback_urls" {
  description = "認証後のコールバックURL（NextJS用）"
  type        = list(string)
  default     = ["http://localhost:3000/auth/callback"]
}

variable "logout_urls" {
  description = "ログアウト後のリダイレクトURL"
  type        = list(string)
  default     = ["http://localhost:3000"]
}

variable "allowed_oauth_flows" {
  description = "許可するOAuthフロー"
  type        = list(string)
  default     = ["code"]
}

variable "allowed_oauth_scopes" {
  description = "許可するOAuthスコープ"
  type        = list(string)
  default     = ["openid", "email", "profile"]
}

variable "tags" {
  description = "リソースに付与するタグ"
  type        = map(string)
  default     = {}
}
