output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.myvpc.id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.myigw.id
}

output "subnet_id" {
  description = "Subnet ID"
  value       = aws_subnet.mysubnet.id
}

output "route_table_id" {
  description = "Route Table ID"
  value       = aws_route_table.myrt.id
}