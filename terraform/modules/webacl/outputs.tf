output "arn" {
  description = "The ARN of the WAFv2 WebACL."
  value       = aws_wafv2_web_acl.this.arn
}

output "id" {
  description = "The ID of the WAFv2 WebACL."
  value       = aws_wafv2_web_acl.this.id
}

output "capacity" {
  description = "The capacity of the WAFv2 WebACL."
  value       = aws_wafv2_web_acl.this.capacity
}
