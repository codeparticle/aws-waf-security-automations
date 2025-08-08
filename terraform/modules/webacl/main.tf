resource "aws_wafv2_web_acl" "this" {
  name  = var.name
  scope = var.scope
  tags  = var.tags

  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [1] : []
      content {}
    }
    dynamic "block" {
      for_each = var.default_action == "block" ? [1] : []
      content {}
    }
  }

  dynamic "rule" {
    for_each = var.rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        dynamic "count" {
            for_each = rule.value.override_action == "count" ? [1] : []
            content {}
        }
        dynamic "none" {
            for_each = rule.value.override_action == "none" ? [1] : []
            content {}
        }
      }

      statement {
        dynamic "managed_rule_group_statement" {
          for_each = rule.value.type == "managed" ? [1] : []
          content {
            name        = rule.value.managed_rule_group_statement.name
            vendor_name = rule.value.managed_rule_group_statement.vendor_name

            dynamic "rule_action_override" {
                for_each = rule.value.managed_rule_group_statement.rule_action_override
                content {
                    name = rule_action_override.value.name
                    action_to_use {
                        dynamic "allow" {
                            for_each = rule_action_override.value.action == "allow" ? [1] : []
                            content {}
                        }
                        dynamic "block" {
                            for_each = rule_action_override.value.action == "block" ? [1] : []
                            content {}
                        }
                        dynamic "count" {
                            for_each = rule_action_override.value.action == "count" ? [1] : []
                            content {}
                        }
                    }
                }
            }
          }
        }

        dynamic "rate_based_statement" {
          for_each = rule.value.type == "rate" ? [1] : []
          content {
            limit              = rule.value.limit
            aggregate_key_type = rule.value.aggregate_key_type
          }
        }

        dynamic "ip_set_reference_statement" {
          for_each = rule.value.type == "ip_set" ? [1] : []
          content {
            arn = rule.value.arn
          }
        }

        dynamic "sqli_match_statement" {
            for_each = rule.value.type == "sqli" ? [1] : []
            content {
                field_to_match {
                    dynamic "all_query_arguments" {
                        for_each = rule.value.field_to_match == "all_query_arguments" ? [1] : []
                        content {}
                    }
                    dynamic "body" {
                        for_each = rule.value.field_to_match == "body" ? [1] : []
                        content {}
                    }
                    dynamic "method" {
                        for_each = rule.value.field_to_match == "method" ? [1] : []
                        content {}
                    }
                    dynamic "uri_path" {
                        for_each = rule.value.field_to_match == "uri_path" ? [1] : []
                        content {}
                    }
                    dynamic "query_string" {
                        for_each = rule.value.field_to_match == "query_string" ? [1] : []
                        content {}
                    }
                }
                text_transformation {
                    priority = rule.value.text_transformation.priority
                    type     = rule.value.text_transformation.type
                }
            }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.name
        sampled_requests_enabled   = true
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.name
    sampled_requests_enabled   = true
  }
}
