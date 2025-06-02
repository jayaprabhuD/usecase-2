
output "rds_instance_endpoint" {
  description = "The endpoint of the Bayer MySQL RDS instance"
  value       = aws_db_instance.mysql.endpoint
}

output "rds_instance_db_name" {
  description = "The name of the Bayer MySQL RDS instance"
  value       = aws_db_instance.mysql.db_name
}

output "rds_subnet_group_name" {
  description = "The name of the Bayer RDS subnet group"
  value       = aws_db_subnet_group.rds_subnet_group.name
}
