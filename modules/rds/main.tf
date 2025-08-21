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
  publicly_accessible   = var.db_publicly_accessible
}

resource "aws_db_subnet_group" "db_subnets" {
  name       = var.db_subnet_group_name
  subnet_ids = var.private_subnet_ids
}

resource "aws_kms_key" "kms_key" {
  enable_key_rotation     = var.kms_enable_key_rotation
  deletion_window_in_days = var.kms_deletion_window_in_days
}

resource "aws_secretsmanager_secret" "rds_cred" {
  name       = var.rds_secret_name
  kms_key_id = aws_kms_key.kms_key.key_id
}

resource "aws_secretsmanager_secret_version" "cred" {
  secret_id = aws_secretsmanager_secret.rds_cred.id
  secret_string = jsonencode({
    username = var.db_username,
    password = var.db_password
  })
}

resource "aws_security_group" "db" {
  name   = var.db_sg_name
  vpc_id = var.vpc_id

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "db_app" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.pub_ids[0]
  vpc_security_group_ids      = [aws_security_group.db.id]
  associate_public_ip_address = true
  key_name                    = var.db_app_key_name

  user_data = base64encode(templatefile("${path.module}/user_data.tftpl", {
    region     = var.region
    secret_arn = aws_secretsmanager_secret.rds_cred.arn
  }))

  tags = {
    Name = var.db_app_name
  }
}
