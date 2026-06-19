variable "bucket_name" {
  description = "Name of the S3 bucket to store Terraform state"
  type        = string
  default     = "myrepo-terraform-state"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "myrepo-terraform-lock"
}

variable "region" {
  description = "AWS region to create backend resources in"
  type        = string
  default     = "us-east-1"
}
