output "lambda_roles" {
  description = "A map of IAM roles for the Lambda functions."
  value       = aws_iam_role.lambda_role
}

output "firehose_role_arn" {
  description = "The ARN of the IAM role for the Kinesis Firehose delivery stream."
  value       = aws_iam_role.firehose_role.arn
}
