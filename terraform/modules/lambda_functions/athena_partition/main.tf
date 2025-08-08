data "archive_file" "this" {
  type        = "zip"
  source_dir  = var.source_code_path
  output_path = "${path.module}/log_parser.zip"
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime
  role          = var.iam_role_arn

  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256

  tags = var.tags
}
