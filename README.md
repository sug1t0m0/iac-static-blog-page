# iac-static-blog-page
静的ブログサイト作成のためのインフラをaws上に構築するterraform

# 環境構築


# 使い方

## tfstate を S3 に保存するための設定

```
cd terraform
```

```
aws-vault exec my-terraform -- terraform init
```



backendのs3の設定を行い
```
aws-vault exec {profile name} -- terraform init -backend-config=backend.env.hcl
```

```
aws-vault exec my-terraform -- terraform workspace new test
```

```
aws-vault exec my-terraform -- terraform apply
```
