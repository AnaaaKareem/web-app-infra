resource "aws_db_instance" "db" {
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  db_name               = var.db_name
  engine                = var.db_engine
  engine_version        = var.db_engine_version
  instance_class        = var.db_instance_class
  username              = var.db_username
  password              = var.db_password
  parameter_group_name  = var.db_parameter_group_name
  skip_final_snapshot   = var.db_skip_final_snapshot
  db_subnet_group_name  = aws_db_subnet_group.db_subnets.name
  publicly_accessible   = false
}

resource "aws_db_subnet_group" "db_subnets" {
  name       = "db-private-subnets"
  subnet_ids = var.private_subnet_ids
}


resource "aws_kms_key" "kms_key" {
  enable_key_rotation     = false
  deletion_window_in_days = 7
}

resource "aws_secretsmanager_secret" "rds_cred" {
  name       = "krdscred-1"
  kms_key_id = aws_kms_key.kms_key.key_id
}

resource "aws_secretsmanager_secret_version" "cred" {
  secret_id = aws_secretsmanager_secret.rds_cred.id
  secret_string = jsonencode({
    username = var.db_username,
    password = var.db_password
  })
}

resource "aws_instance" "db_app" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.ps_ids[0]
  vpc_security_group_ids = [var.ec2sg]

  user_data = file("${path.module}/user_data.sh")
}