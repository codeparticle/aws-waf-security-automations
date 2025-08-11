resource "aws_s3_bucket" "waf_log_bucket" {
  bucket = var.waf_log_bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "waf_log_bucket_acl" {
  bucket = aws_s3_bucket.waf_log_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket" "app_access_log_bucket" {
  bucket = var.app_access_log_bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "app_access_log_bucket_acl" {
  bucket = aws_s3_bucket.app_access_log_bucket.id
  acl    = "private"
}

resource "aws_kinesis_firehose_delivery_stream" "this" {
  name        = var.firehose_delivery_stream_name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.waf_log_bucket.arn

    processing_configuration {
      enabled = true
      processors {
        type = "Lambda"
        parameter {
          parameter_name  = "LambdaArn"
          parameter_value = var.log_parser_lambda_arn
        }
      }
    }
  }
}

resource "aws_iam_role" "firehose_role" {
  name = "${var.firehose_delivery_stream_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "firehose_policy" {
  name = "${var.firehose_delivery_stream_name}-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.waf_log_bucket.arn,
          "${aws_s3_bucket.waf_log_bucket.arn}/*"
        ]
      },
      {
        Action   = "lambda:InvokeFunction"
        Effect   = "Allow"
        Resource = var.log_parser_lambda_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "firehose_policy_attachment" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose_policy.arn
}

resource "aws_glue_catalog_database" "this" {
  name = var.glue_database_name
}

resource "aws_glue_catalog_table" "this" {
  name          = var.glue_table_name
  database_name = aws_glue_catalog_database.this.name

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.waf_log_bucket.bucket}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "JsonSerDe"
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
      parameters = {
        "serialization.format" = "1"
      }
    }

    columns {
      name = "timestamp"
      type = "bigint"
    }

    columns {
      name = "formatversion"
      type = "int"
    }

    columns {
        name = "webaclid"
        type = "string"
    }

    columns {
        name = "terminatingruleid"
        type = "string"
    }

    columns {
        name = "terminatingruletype"
        type = "string"
    }

    columns {
        name = "action"
        type = "string"
    }

    columns {
        name = "terminatingrulematchdetails"
        type = "array<struct<conditiontype:string,location:string,matcheddata:array<string>>>"
    }

    columns {
        name = "httpslogsource"
        type = "struct<httpsourcename:string,httpsourceid:string>"
    }

    columns {
        name = "httpsourcerequest"
        type = "struct<clientip:string,country:string,headers:array<struct<name:string,value:string>>,uri:string,args:string,httpversion:string,httpmethod:string,requestid:string>"
    }
  }
}
