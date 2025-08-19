resource "aws_launch_template" "launch" {
  name = "nginx-server-"

  image_id = var.ami
  instance_type = var.instance_type
  key_name = "sandbox"

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.ec2sg.id]
    subnet_id = var.public_subnet_ids[0]
  }

  user_data = base64encode(<<EOF
            #!/bin/bash

            # Nginx Server
            sudo apt update -y
            sudo apt install -y nginx
            sudo systemctl enable nginx
            sudo systemctl start nginx
            sudo echo "<html>" >> /var/www/html/index.html
            sudo echo "<body>" >> /var/www/html/index.html
            sudo echo "<h1>Hello from Karim</h1>" >> /var/www/html/index.html
            sudo echo "<h2>Date: 19/08/2025</h2>" >> /var/www/html/index.html
            sudo echo "</body>" >> /var/www/html/index.html
            sudo echo "</html>" >> /var/www/html/index.html
            EOF
  )
}

resource "aws_autoscaling_group" "autoscaler" {
  name                      = "Web Autoscaler"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 400
  health_check_type         = "ELB"
  desired_capacity          = 3
  force_delete              = true
  vpc_zone_identifier       = var.public_subnet_ids

  instance_maintenance_policy {
    min_healthy_percentage = 40
    max_healthy_percentage = 100
  }

  launch_template {
    id      = aws_launch_template.launch.id
    version = "$Latest"
  }
}

resource "aws_security_group" "ec2sg" {
  name   = "Karim-EC2-SG"
  vpc_id = var.vpc_id

  ingress {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
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
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [var.cidr_block]
  }
  
}

resource "aws_security_group" "albsg" {
  name   = "Karim-ALB-SG"
  vpc_id = var.vpc_id

  ingress {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [var.cidr_block]
  }
  
}

resource "aws_lb" "load_balancer" {
  name               = "k-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.albsg.id]
  subnets            = var.public_subnet_ids
}