output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.server.id
}

output "public_ip" {
  description = "Public IP address of the instance"
  value       = aws_instance.server.public_ip
}

output "private_ip" {
  description = "Private IP address of the instance"
  value       = aws_instance.server.private_ip
}

output "key_pair_name" {
  description = "Key pair name"
  value       = aws_key_pair.deployer.key_name
}
