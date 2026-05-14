provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "digvijay" {
    instance_type = "t2.micro"
    ami = "ami-05cf1e9f73fbad2e2"
}


resource "aws_s3_bucket" "s3_bucket" {
    bucket = "digvijay-s3-demo-xyz"
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}