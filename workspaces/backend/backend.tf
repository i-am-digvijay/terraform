terraform {
  backend "s3" {
    bucket         = "myrepo-terraform-state"
    region               = "us-east-1"
    dynamodb_table       = "myrepo-terraform-lock"
    encrypt              = true
    workspace_key_prefix = "multienv"
  }
}