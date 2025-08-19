output "ami" {
  value = var.ami
}

output "ec2sg" {
  value = aws_security_group.ec2sg.id
}