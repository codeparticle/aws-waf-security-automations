output "waf_log_bucket_arn" {
  description = "The ARN of the WAF log bucket."
  value       = aws_s3_bucket.waf_log_bucket.arn
}

output "app_access_log_bucket_arn" {
  description = "The ARN of the application access log bucket."
  value       = aws_s3_bucket.app_access_log_bucket.arn
}

output "firehose_delivery_stream_arn" {
  description = "The ARN of the Kinesis Firehose delivery stream."
  value       = aws_kinesis_firehose_delivery_stream.this.arn
}

output "glue_database_name" {
  description = "The name of the Glue database."
  value       = aws_glue_catalog_database.this.name
}

output "glue_table_name" {
  description = "The name of the Glue table."
  value       = aws_glue_catalog_table.this.name
}
