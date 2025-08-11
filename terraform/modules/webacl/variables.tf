variable "name" {
  description = "The name of the WebACL."
  type        = string
}

variable "scope" {
  description = "The scope of this Web ACL. Valid values are CLOUDFRONT or REGIONAL."
  type        = string
  default     = "CLOUDFRONT"
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "default_action" {
  description = "The action to perform if none of the rules match."
  type        = string
  default     = "allow"
}

variable "rules" {
  description = "A list of rules to apply to the WebACL."
  type        = any
  default     = []
}
