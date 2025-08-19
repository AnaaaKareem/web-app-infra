resource "aws_iam_role" "EC2-role" {
  name = "EC2-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "EC2-policy" {
  name = "EC2-Policy"

  policy = templatefile("modules/iam/policy.json", {
    s3_arn = var.s3_arn,
    sm_arn = var.rds_arn
  })
}

resource "aws_iam_role_policy_attachment" "role_attachment" {
  role       = aws_iam_role.EC2-role.name
  policy_arn = aws_iam_policy.EC2-policy.arn
}
