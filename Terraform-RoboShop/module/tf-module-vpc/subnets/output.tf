# To list the created subnets detail to filter public and private form there.

output "subnet_ids" {
  value = aws_subnet.main
}

output "route_table_ids" {
  value = aws_route_table.main
}

