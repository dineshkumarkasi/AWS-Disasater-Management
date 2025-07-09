# outputs.tf

output "rds_endpoint" {
  description = "RDS Endpoint to connect to the MySQL DB"
  value       = aws_db_instance.primary_rds.endpoint
}

output "rds_db_name" {
  description = "Name of the RDS database"
  value       = aws_db_instance.primary_rds.db_name
}

output "ec2_primary_public_ip" {
  description = "Public IP of the Primary EC2 instance"
  value       = aws_instance.web-primary.public_ip
}

output "ec2_secondary_public_ip" {
  description = "Public IP of the Secondary EC2 instance"
  value       = aws_instance.web-secondary.public_ip
}
