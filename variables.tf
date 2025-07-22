# 変数定義
variable "aws_region" {
  description = "AWS リージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "service" {
  description = "サービス名"
  type        = string
  default     = "my-app"
}

variable "environment" {
  description = "環境名"
  type        = string
  default     = "dev"
}

variable "callback_urls" {
  description = "認証後のコールバックURL（NextJS用）"
  type        = list(string)
  default = [
    "http://localhost:3000/auth/callback",
    "https://your-domain.com/auth/callback"
  ]
}

variable "logout_urls" {
  description = "ログアウト後のリダイレクトURL"
  type        = list(string)
  default = [
    "http://localhost:3000",
    "https://your-domain.com"
  ]
} 