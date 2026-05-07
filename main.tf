provider "aws" {
  region = "us-east-1"
}

module "ec2_instance" {
  source = "./module/ec2_instance"
  ami_value="ami-05cf1e9f73fbad2e2"
  instance_type_value = "t2.micro"
}