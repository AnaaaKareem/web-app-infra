resource "aws_launch_template" "launch" {
  name = "${var.name_prefix}-nginx-server-lt"

  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2sg.id]
  }

  user_data = base64encode(templatefile("${path.module}/user_data.tftpl", {
    name = var.user_name
    date = formatdate("DD MMMM YYYY", timestamp())
  }))

  tags = {
    Name = "${var.name_prefix}-nginx-launch-template"
  }
}

resource "aws_autoscaling_group" "autoscaler" {
  name                      = "${var.name_prefix}-Web-Autoscaler"
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  health_check_grace_period = var.asg_health_check_grace_period
  health_check_type         = var.asg_health_check_type
  desired_capacity          = var.asg_desired_capacity
  force_delete              = var.asg_force_delete
  vpc_zone_identifier       = var.public_subnet_ids
  target_group_arns         = [aws_lb_target_group.tg.arn]

  instance_maintenance_policy {
    min_healthy_percentage = var.asg_min_healthy_percentage
    max_healthy_percentage = var.asg_max_healthy_percentage
  }

  launch_template {
    id      = aws_launch_template.launch.id
    version = "$Latest"
  }

  depends_on = [aws_launch_template.launch]
}

resource "aws_security_group" "ec2sg" {
  name   = var.ec2_sg_name
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
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "albsg" {
  name   = var.alb_sg_name
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
    cidr_blocks = [var.alb_egress_cidr]
  }
}

resource "aws_lb_target_group" "tg" {
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = var.tg_health_path
    interval            = var.tg_health_interval
    timeout             = var.tg_health_timeout
    healthy_threshold   = var.tg_health_healthy_threshold
    unhealthy_threshold = var.tg_health_unhealthy_threshold
    matcher             = var.tg_health_matcher
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.lb_listener_port
  protocol          = var.lb_listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb" "load_balancer" {
  name               = var.load_balancer_name
  internal           = var.load_balancer_internal
  load_balancer_type = var.load_balancer_type
  ip_address_type    = var.load_balancer_ip_address_type
  security_groups    = [aws_security_group.albsg.id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = var.load_balancer_tag_name
  }
}
