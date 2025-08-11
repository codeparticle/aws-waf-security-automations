variable "waf_log_bucket_name" {
  description = "The name of the S3 bucket for WAF logs."
  type        = string
}

variable "app_access_log_bucket_name" {
  description = "The name of the S3 bucket for application access logs."
  type        = string
}

variable "firehose_delivery_stream_name" {
  description = "The name of the Kinesis Firehose delivery stream."
  type        = string
}

variable "glue_database_name" {
  description = "The name of the Glue database."
  type        = string
}

variable "glue_table_name" {
  description = "The name of the Glue table."
  type        = string
}

variable "log_parser_lambda_arn" {
  description = "The ARN of the log parser Lambda function."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
