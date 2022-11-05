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