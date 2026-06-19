
variable "ami_value" {
  description = "AMI ID for EC2 instance"
  type        = string
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
variable "ssh_private_key_path" {
  description = "Path to SSH private key"
  type        = string
  default     = "C:\\Users\\digvi\\.ssh\\id_rsa"
}
variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "C:\\Users\\digvi\\.ssh\\id_rsa.pub"
}
variable "app_script_path" {
  description = "Path to application script (app.py)"
  type        = string
  default     = "./app.py"
}