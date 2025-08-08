module "iam" {
  source = "./modules/iam"

  name_prefix = var.solution_name

  lambda_functions = {
    "log_parser" : {},
    "reputation_lists_parser" : {},
    "ip_retention" : {},
    "helper" : {},
    "custom_resource" : {},
    "athena_partition" : {},
    "metrics" : {}
  }
}

module "log_parser_lambda" {
  source = "./modules/lambda_functions/log_parser"

  function_name    = "${var.solution_name}-log-parser"
  handler          = "log_parser.handler"
  runtime          = "python3.12"
  source_code_path = "../source/log_parser/"
  iam_role_arn     = module.iam.lambda_roles["log_parser"].arn
  tags             = var.tags
}
