variable "aws_region" {
  description = "The AWS region to deploy the resources to."
  type        = string
  default     = "us-east-1"
}

variable "solution_name" {
  description = "The name of the solution."
  type        = string
  default     = "aws-waf-security-automations"
}

variable "scope" {
  description = "The scope of this Web ACL. Valid values are CLOUDFRONT or REGIONAL."
  type        = string
  default     = "CLOUDFRONT"
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
