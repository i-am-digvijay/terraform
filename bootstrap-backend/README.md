Bootstrap backend
-----------------

This folder bootstraps a single S3 bucket and a DynamoDB table used as the Terraform remote backend and lock table.

Usage

1. Initialize and apply the bootstrap (it uses a local backend so it can create the remote backend resources):

```bash
cd terraform/bootstrap-backend
terraform init
terraform apply -var='bucket_name=myrepo-terraform-state' -var='dynamodb_table_name=myrepo-terraform-lock' -auto-approve
```

2. After creation, use these values when running `terraform init` in your main project:

```bash
cd ../../multienv
terraform init \
  -backend-config="bucket=myrepo-terraform-state" \
  -backend-config="dynamodb_table=myrepo-terraform-lock" \
  -backend-config="key=multienv/dev/terraform.tfstate"
```

Adjust `key` per environment (`multienv/dev/...`, `multienv/stage/...`, `multienv/prod/...`).
