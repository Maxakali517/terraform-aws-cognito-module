# Cognito User Pool Terraform Module

NextJS SPA + FastAPI構成に最適化されたAWS Cognitoユーザープール用のTerraformモジュールです。

## 🏗️ アーキテクチャ

### 認証フロー

```mermaid
sequenceDiagram
    participant User as ユーザー
    participant NextJS as NextJS
    participant FastAPI as FastAPI
    participant Cognito as Cognito

    User->>NextJS: ログイン
    NextJS->>Cognito: 認証<br/>(SPAクライアント)
    Cognito->>NextJS: JWT返却
    NextJS->>FastAPI: API呼び出し<br/>(JWT付き)
    FastAPI->>Cognito: JWT検証 (JWKS)
    Note over FastAPI: user subを取得
    FastAPI->>NextJS: レスポンス
```

### 構成要素

- **Cognitoユーザープール**: ユーザー認証・管理
- **SPAクライアント**: NextJS用（クライアントシークレットなし）
- **ユーザープールドメイン**: Hosted UI用
- **JWT検証**: FastAPIでのトークン検証

## 📁 ファイル構成

```
.
├── README.md           # このファイル
├── provider.tf         # Terraformプロバイダー設定
├── variables.tf        # ルートレベル変数定義
├── outputs.tf          # 出力定義
├── main.tf            # Cognitoモジュール呼び出し
└── modules/
    └── cognito/
        ├── main.tf     # Cognitoリソース定義
        ├── variables.tf # モジュール変数定義
        └── outputs.tf  # モジュール出力定義
```

## 🔧 変数説明

### ルートレベル変数 (`variables.tf`)

| 変数名 | 型 | デフォルト値 | 説明 |
|--------|----|--------------|----- |
| `aws_region` | string | `"ap-northeast-1"` | **AWSリージョン**<br/>Cognitoリソースを作成するAWSリージョンを指定 |
| `service` | string | `"my-app"` | **サービス名**<br/>リソース名の命名に使用（例: my-app-dev-user-pool） |
| `environment` | string | `"dev"` | **環境名**<br/>dev, staging, prod などの環境識別子 |
| `callback_urls` | list(string) | `["http://localhost:3000/auth/callback", "https://your-domain.com/auth/callback"]` | **認証後のコールバックURL**<br/>NextJSアプリで認証成功後のリダイレクト先 |
| `logout_urls` | list(string) | `["http://localhost:3000", "https://your-domain.com"]` | **ログアウト後のリダイレクトURL**<br/>ログアウト後にリダイレクトする先 |

### Cognitoモジュール変数 (`modules/cognito/variables.tf`)

#### 基本設定

| 変数名 | 型 | デフォルト値 | 説明 |
|--------|----|--------------|----- |
| `service` | string | - | **サービス名**<br/>命名プレフィックスに使用（例: my-app-dev-user-pool） |
| `environment` | string | - | **環境名**<br/>dev, staging, prod などの環境識別子（必須） |
| `region` | string | - | **AWSリージョン**<br/>JWT issuer URLの生成に使用 |

#### パスワードポリシー設定

| 変数名 | 型 | デフォルト値 | 説明 |
|--------|----|--------------|----- |
| `password_minimum_length` | number | `8` | **パスワード最小文字数**<br/>ユーザーが設定するパスワードの最小文字数 |
| `password_require_lowercase` | bool | `true` | **小文字必須フラグ**<br/>パスワードに小文字を必須とするか |
| `password_require_uppercase` | bool | `true` | **大文字必須フラグ**<br/>パスワードに大文字を必須とするか |
| `password_require_numbers` | bool | `true` | **数字必須フラグ**<br/>パスワードに数字を必須とするか |
| `password_require_symbols` | bool | `false` | **記号必須フラグ**<br/>パスワードに記号を必須とするか |

#### OAuth設定

| 変数名 | 型 | デフォルト値 | 説明 |
|--------|----|--------------|----- |
| `allowed_oauth_flows` | list(string) | `["code"]` | **許可するOAuthフロー**<br/>通常はSPA用のauthorization codeフロー |
| `allowed_oauth_scopes` | list(string) | `["openid", "email", "profile"]` | **許可するOAuthスコープ**<br/>取得可能なユーザー情報の範囲 |
| `callback_urls` | list(string) | `["http://localhost:3000/auth/callback"]` | **認証後のコールバックURL**<br/>NextJSアプリで認証成功後のリダイレクト先 |
| `logout_urls` | list(string) | `["http://localhost:3000"]` | **ログアウト後のリダイレクトURL**<br/>ログアウト後にリダイレクトする先 |

#### その他設定

| 変数名 | 型 | デフォルト値 | 説明 |
|--------|----|--------------|----- |
| `app_client_name` | string | `""` | **Cognitoアプリクライアント名**<br/>空文字の場合は自動生成される |
| `tags` | map(string) | `{}` | **リソースタグ**<br/>Cognitoリソースに付与する追加タグ |

## 📤 出力値

### 基本情報

| 出力名 | 説明 |
|--------|----- |
| `cognito_region` | AWSリージョン |
| `cognito_user_pool_id` | CognitoユーザープールID |
| `cognito_client_id` | CognitoアプリクライアントID（SPA用） |
| `cognito_issuer` | JWT Issuer URL |
| `cognito_jwks_url` | JWKS URL |
| `cognito_hosted_ui_url` | Cognito Hosted UI URL |

### フロントエンド用環境変数

`frontend_env_vars` 出力には以下の環境変数が含まれます：

```bash
NEXT_PUBLIC_AWS_REGION="ap-northeast-1"
NEXT_PUBLIC_USER_POOL_ID="ap-northeast-1_XXXXXXXXX"
NEXT_PUBLIC_USER_POOL_CLIENT_ID="xxxxxxxxxxxxxxxxxxxxxxxxxx"
NEXT_PUBLIC_OAUTH_DOMAIN="my-app-dev-auth"
NEXT_PUBLIC_REDIRECT_URI="http://localhost:3000/auth/callback"
NEXT_PUBLIC_LOGOUT_URI="http://localhost:3000"
```

### バックエンド用環境変数

`backend_env_vars` 出力には以下の環境変数が含まれます：

```bash
AWS_REGION="ap-northeast-1"
USER_POOL_ID="ap-northeast-1_XXXXXXXXX"
CLIENT_ID="xxxxxxxxxxxxxxxxxxxxxxxxxx"
ISSUER="https://cognito-idp.ap-northeast-1.amazonaws.com/ap-northeast-1_XXXXXXXXX"
JWKS_URL="https://cognito-idp.ap-northeast-1.amazonaws.com/ap-northeast-1_XXXXXXXXX/.well-known/jwks.json"
```

## 🚀 使用方法

### 1. 基本的な使用例

```bash
# Terraformの初期化
terraform init

# 設定内容の確認
terraform plan

# リソースの作成
terraform apply
```

### 2. カスタム設定での使用例

`terraform.tfvars` ファイルを作成して設定をカスタマイズ：

```hcl
# terraform.tfvars
aws_region  = "us-west-2"
service     = "my-awesome-app"
environment = "prod"

callback_urls = [
  "https://app.example.com/auth/callback",
  "https://staging.example.com/auth/callback"
]

logout_urls = [
  "https://app.example.com",
  "https://staging.example.com"
]
```

### 3. 環境変数の取得

```bash
# フロントエンド用環境変数
terraform output frontend_env_vars

# バックエンド用環境変数
terraform output backend_env_vars

# 特定の値のみ取得
terraform output cognito_user_pool_id
terraform output cognito_issuer
```

### 4. Hosted UIでのテスト

```bash
# 完全なログインURLを取得
terraform output -raw cognito_hosted_ui_login_url

# このURLをブラウザで開くとCognitoのログインページが表示されます
# 注意: NextJSアプリがポート3000で起動している必要があります
```

## 🔒 セキュリティ考慮事項

### SPAクライアント設定

- **クライアントシークレットなし**: SPAは公開クライアントのためシークレット不要
- **PKCE対応**: セキュリティ強化のためPKCE（Proof Key for Code Exchange）を使用
- **トークン有効期限**: アクセストークン24時間、リフレッシュトークン30日

### JWT検証（FastAPI用）

- **JWKS使用**: 公開鍵による署名検証
- **issuer検証**: JWTのissuerクレームを検証
- **sub取得**: ユーザー識別子（sub）をJWTから取得

## 🏷️ タグと命名規則

### タグ管理

プロバイダーレベルで以下のタグが自動的に全リソースに適用されます：

```hcl
default_tags {
  tags = {
    Service     = var.service
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
```

### 命名規則

すべてのリソースは`service-environment-`プレフィックスで命名されます：

- **ユーザープール**: `my-app-dev-user-pool`
- **SPAクライアント**: `my-app-dev-spa-client`
- **ドメイン**: `my-app-dev-auth`

## 🔧 トラブルシューティング

### よくある問題

1. **ドメイン名の重複エラー**
   - `service`と`environment`の組み合わせで一意になるよう調整

2. **コールバックURLの設定ミス**
   - NextJSアプリのルートと一致しているか確認

3. **JWT検証エラー**
   - `issuer`と`jwks_url`が正しく設定されているか確認

4. **Schema変更エラー**
   ```
   Error: cannot modify or remove schema items
   ```
   - **原因**: Cognitoのschema（ユーザー属性）は作成後変更不可
   - **解決**: `lifecycle { ignore_changes = [schema] }`で回避済み

5. **Hosted UIでエラー表示**
   ```
   An error was encountered with the requested page.
   ```
   - **原因**: `supported_identity_providers`が未設定
   - **解決**: `supported_identity_providers = ["COGNITO"]`で修正済み

### ログの確認

```bash
# Terraformログレベルの設定
export TF_LOG=DEBUG
terraform apply
```

## 📝 開発者向け情報

### NextJS統合例

```typescript
// cognito.config.ts
export const cognitoConfig = {
  region: process.env.NEXT_PUBLIC_AWS_REGION!,
  userPoolId: process.env.NEXT_PUBLIC_USER_POOL_ID!,
  clientId: process.env.NEXT_PUBLIC_USER_POOL_CLIENT_ID!,
  domain: process.env.NEXT_PUBLIC_OAUTH_DOMAIN!,
};
```

### FastAPI統合例

```python
# cognito.py
import os
from jose import jwt
from jose.backends import RSAKey
import requests

REGION = os.environ["AWS_REGION"]
USER_POOL_ID = os.environ["USER_POOL_ID"]
CLIENT_ID = os.environ["CLIENT_ID"]
ISSUER = os.environ["ISSUER"]
JWKS_URL = os.environ["JWKS_URL"]

def verify_jwt(token: str) -> dict:
    """
    JWT検証を行う
    - 署名検証（JWKS使用）
    - issuer検証
    - audience検証（CLIENT_ID）
    - 有効期限検証
    """
    # JWKS取得
    response = requests.get(JWKS_URL)
    jwks = response.json()
    
    # JWT検証
    try:
        payload = jwt.decode(
            token,
            jwks,
            algorithms=["RS256"],
            audience=CLIENT_ID,  # audience検証でクライアントIDをチェック
            issuer=ISSUER,
            options={"verify_exp": True}
        )
        return payload
    except jwt.JWTError:
        raise ValueError("Invalid token")
```