resource "aws_iam_role" "EC2-role" {
  name = var.ec2_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = var.ec2_assume_service
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "EC2-policy" {
  name = var.ec2_policy_name

  policy = templatefile("modules/iam/policy.json", {
    s3_arn = var.s3_arn,
    sm_arn = var.rds_arn
  })
}

resource "aws_iam_role_policy_attachment" "role_attachment" {
  role       = aws_iam_role.EC2-role.name
  policy_arn = aws_iam_policy.EC2-policy.arn
}