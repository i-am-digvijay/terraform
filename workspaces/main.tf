# Workspace configuration mapping
locals {
  workspace_config = {
    dev = {
      region               = "us-east-1"
      environment          = "dev"
      vpc_cidr             = "10.0.0.0/16"
      subnet_cidr          = "10.0.1.0/24"
      availability_zone    = "us-east-1a"
      allowed_ssh_cidr     = "0.0.0.0/0" # Allow SSH from anywhere for dev
      enable_backups       = false
    }
    stage = {
      region               = "us-east-1"
      environment          = "stage"
      vpc_cidr             = "10.1.0.0/16"
      subnet_cidr          = "10.1.1.0/24"
      availability_zone    = "us-east-1a"
      allowed_ssh_cidr     = "0.0.0.0/0" # this is not recommended for production environments, but for demo purposes, we are allowing SSH access from anywhere
      enable_backups       = true
    }
    prod = {
      region               = "us-east-1"
      environment          = "prod"
      vpc_cidr             = "10.2.0.0/16"
      subnet_cidr          = "10.2.1.0/24"
      availability_zone    = "us-east-1a"
      allowed_ssh_cidr     = "203.0.113.0/32"
      enable_backups       = true
    }
    
  }
}

locals {
  workspace_vars = lookup(local.workspace_config, terraform.workspace, local.workspace_config["dev"])
}

provider "aws" {
    region = local.workspace_vars.region
}


module "vpc" {
  source = "./modules/vpc"

  environment       = local.workspace_vars.environment
  vpc_cidr         = local.workspace_vars.vpc_cidr
  subnet_cidr      = local.workspace_vars.subnet_cidr
  availability_zone = local.workspace_vars.availability_zone
}

module "security" {
  source = "./modules/security"

  environment       = local.workspace_vars.environment
  vpc_id            = module.vpc.vpc_id
  allowed_ssh_cidr  = local.workspace_vars.allowed_ssh_cidr
}

module "compute" {
  source = "./modules/compute"
  ami_id              = var.ami_value
  environment          = local.workspace_vars.environment
  instance_type       = var.instance_type
  security_group_id   = module.security.security_group_id
  subnet_id           = module.vpc.subnet_id
  ssh_private_key_path        = var.ssh_private_key_path
  ssh_public_key_path         = var.ssh_public_key_path
  app_script_path     = var.app_script_path
}
