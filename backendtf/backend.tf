terraform {
  backend "s3" {
    bucket = "digvijay-s3-demo-xyz"
    key    = "digvijay/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile   = true 
    # dynamodb_table = "terraform-lock" DynamoDB-based state locking is officially deprecated in the Terraform S3 backend
  }
}
