output "rds_endpoint" {
  value = aws_db_instance.db.endpoint
}

output "sm_arn" {
  value = aws_secretsmanager_secret.rds_cred.arn
}