resource "aws_iam_role" "lambda_role" {
  for_each = var.lambda_functions

  name = "${var.name_prefix}-${each.key}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  for_each = var.lambda_functions

  name        = "${var.name_prefix}-${each.key}-policy"
  description = "IAM policy for ${each.key} lambda function"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
        {
            Action = [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            Effect   = "Allow",
            Resource = "arn:aws:logs:*:*:*"
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_attachment" {
  for_each = var.lambda_functions

  role       = aws_iam_role.lambda_role[each.key].name
  policy_arn = aws_iam_policy.lambda_policy[each.key].arn
}

resource "aws_iam_role" "firehose_role" {
  name = "${var.name_prefix}-firehose-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })
}
