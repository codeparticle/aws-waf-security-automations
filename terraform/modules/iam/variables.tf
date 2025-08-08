variable "name_prefix" {
  description = "The prefix to use for the names of the IAM roles and policies."
  type        = string
}

variable "lambda_functions" {
    description = "A map of lambda functions to create roles for."
    type = map(object({
        name = string
    }))
    default = {}
}
