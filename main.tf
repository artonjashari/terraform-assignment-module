resource "aws_iam_user" "lb" {
  name = var.user_name
  path = "/system/"
}

resource "aws_iam_user_login_profile" "example" {
  user                    = aws_iam_user.lb.name
  password_reset_required = true

  lifecycle {
    ignore_changes = [password_reset_required]
  }
}

resource "aws_iam_user_policy" "lb_ro" {
  name = var.policy_name
  user = aws_iam_user.lb.name
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode(var.policy_document)
}

module "user-arton-modulee" {
  source  = "app.terraform.io/artonjashari/user-arton-modulee/iam"
  version = "1.0.2"
  # insert required variables here

  user_name = "arton-user"
  policy_name = "arton-policy"

  policy_document = {
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*", "iam:GetAccountPasswordPolicy", "elasticloadbalancing:DescribeLoadBalancers"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "iam:ChangePassword"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  
  }
}