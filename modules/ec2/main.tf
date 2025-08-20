resource "aws_launch_template" "launch" {
  name = "${var.name_prefix}-nginx-server-lt"

  image_id = var.ami
  instance_type = var.instance_type
  key_name = "sandbox"

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.ec2sg.id]
  }

  user_data = base64encode(templatefile("${path.module}/user_data.tftpl", {
    name = "Karim"
    date = formatdate("DD MMMM YYYY", timestamp())
  }))

  tags = {
    Name = "${var.name_prefix}-nginx-launch-template"
  }
}

resource "aws_autoscaling_group" "autoscaler" {
  name                      = "${var.name_prefix}-Web-Autoscaler"
  max_size                  = 2
  min_size                  = 2
  health_check_grace_period = 400
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  vpc_zone_identifier       = var.public_subnet_ids
  target_group_arns = [aws_lb_target_group.tg.arn]

  instance_maintenance_policy {
    min_healthy_percentage = 40
    max_healthy_percentage = 100
  }

  launch_template {
    id      = aws_launch_template.launch.id
    version = "$Latest"
  }
  depends_on = [ aws_launch_template.launch ]
}

resource "aws_security_group" "ec2sg" {
  name   = "Karim-EC2-SG"
  vpc_id = var.vpc_id

  ingress {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      #security_groups = [aws_security_group.albsg.id]
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
      cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_lb_target_group" "tg" {
  name     = "nginx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb" "load_balancer" {
  name               = "k-load-balancer"
  internal           = false
  load_balancer_type = "application"
  ip_address_type = "ipv4"
  security_groups    = [aws_security_group.albsg.id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "Load_Balance"
  }
}