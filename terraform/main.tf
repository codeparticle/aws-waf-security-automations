module "iam" {
  source = "./modules/iam"

  name_prefix = var.solution_name

  lambda_functions = {
    "log_parser" : {},
    "reputation_lists_parser" : {},
    "set_ip_retention" : {},
    "remove_expired_ip" : {},
    "helper" : {},
    "custom_resource" : {},
    "athena_partition" : {},
    "metrics" : {}
  }
}

module "log_parser_lambda" {
  source = "./modules/lambda_functions/log_parser"

  function_name = "${var.solution_name}-log-parser"
  handler       = "log_parser.handler"
  runtime       = "python3.12"
  filename      = "placeholder.zip" # placeholder
  iam_role_arn  = module.iam.lambda_roles["log_parser"].arn
  tags          = var.tags
}

module "reputation_lists_parser_lambda" {
  source = "./modules/lambda_functions/reputation_lists_parser"

  function_name = "${var.solution_name}-reputation-lists-parser"
  handler       = "reputation_lists.handler"
  runtime       = "python3.12"
  filename      = "placeholder.zip" # placeholder
  iam_role_arn  = module.iam.lambda_roles["reputation_lists_parser"].arn
  tags          = var.tags
}

module "set_ip_retention_lambda" {
  source = "./modules/lambda_functions/set_ip_retention"

  function_name = "${var.solution_name}-set-ip-retention"
  handler       = "set_ip_retention.handler"
  runtime       = "python3.12"
  filename      = "placeholder.zip" # placeholder
  iam_role_arn  = module.iam.lambda_roles["set_ip_retention"].arn
  tags          = var.tags
}

module "remove_expired_ip_lambda" {
  source = "./modules/lambda_functions/remove_expired_ip"

  function_name = "${var.solution_name}-remove-expired-ip"
  handler       = "remove_expired_ip.handler"
  runtime       = "python3.12"
  filename      = "placeholder.zip" # placeholder
  iam_role_arn  = module.iam.lambda_roles["remove_expired_ip"].arn
  tags          = var.tags
}

module "helper_lambda" {
  source = "./modules/lambda_functions/helper"

  function_name = "${var.solution_name}-helper"
  handler       = "helper.handler"
  runtime       = "python3.12"
  filename      = "placeholder.zip" # placeholder
  iam_role_arn  = module.iam.lambda_roles["helper"].arn
  tags          = var.tags
}

module "custom_resource_lambda" {
  source = "./modules/lambda_functions/custom_resource"

  function_name = "${var.solution_name}-custom-resource"
  handler       = "custom_resource.handler"
  runtime       = "python3.12"
  filename      = "placeholder.zip" # placeholder
  iam_role_arn  = module.iam.lambda_roles["custom_resource"].arn
  tags          = var.tags
}

module "athena_partition_lambda" {
  source = "./modules/lambda_functions/athena_partition"

  function_name = "${var.solution_name}-athena-partition"
  handler       = "athena_partition.handler"
  runtime       = "python3.12"
  filename      = "placeholder.zip" # placeholder
  iam_role_arn  = module.iam.lambda_roles["athena_partition"].arn
  tags          = var.tags
}

module "metrics_lambda" {
  source = "./modules/lambda_functions/metrics"

  function_name = "${var.solution_name}-metrics"
  handler       = "metrics.handler"
  runtime       = "python3.12"
  filename      = "placeholder.zip" # placeholder
  iam_role_arn  = module.iam.lambda_roles["metrics"].arn
  tags          = var.tags
}

module "logging" {
  source = "./modules/logging"

  waf_log_bucket_name           = "${var.solution_name}-waf-logs"
  app_access_log_bucket_name    = "${var.solution_name}-app-access-logs"
  firehose_delivery_stream_name = "${var.solution_name}-firehose"
  glue_database_name            = "${var.solution_name}-glue-db"
  glue_table_name               = "${var.solution_name}-waf-logs"
  log_parser_lambda_arn         = module.log_parser_lambda.arn
  tags                          = var.tags
}

module "webacl" {
  source = "./modules/webacl"

  name  = "${var.solution_name}-webacl"
  scope = var.scope
  tags  = var.tags
  # I will add rules later
}
