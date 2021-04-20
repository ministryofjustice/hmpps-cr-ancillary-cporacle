# #--------------------------------------------
# ### S3 bucket ALB Access Logs
# #--------------------------------------------
# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html

data "aws_kms_alias" "s3" {
  name = "alias/aws/s3"
}

resource "aws_s3_bucket" "alb_access_logs_s3_bucket" {
  bucket = local.alb_access_logs_s3_bucket_name
  acl    = "private"

  versioning {
    enabled    = true
    mfa_delete = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        # kms_master_key_id = data.aws_kms_alias.s3.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = local.tags
  
}

resource "aws_s3_bucket_public_access_block" "alb_access_logs_s3_bucket_public_access_block" {
  bucket = local.alb_access_logs_s3_bucket_name

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true

  depends_on = [
    aws_s3_bucket.alb_access_logs_s3_bucket
  ]
}

data "template_file" "alb_access_logs_s3_bucket_policy" {

  template = file("policies/s3_access_logs_bucket_policy.tpl")

  vars = {
    account_id  = local.account_id
    bucket_name = local.alb_access_logs_s3_bucket_name
    prefix      = local.common_name
  }
}

resource "null_resource" "alb_access_logs_s3_bucket_policy_rendered" {
  triggers = {
    json = data.template_file.alb_access_logs_s3_bucket_policy.rendered
  }
}

resource "aws_s3_bucket_policy" "alb_access_logs_s3_bucket_policy" {
  bucket = aws_s3_bucket.alb_access_logs_s3_bucket.id
  policy = data.template_file.alb_access_logs_s3_bucket_policy.rendered
}

resource "aws_s3_bucket" "cporacle_artifacts" {
  bucket = local.artifacts_s3_bucket_name
  acl    = "private"

  versioning {
    enabled    = true
    mfa_delete = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = local.tags
}

resource "aws_s3_bucket_public_access_block" "cporacle_artifacts_bucket_public_access_block" {
  bucket = local.artifacts_s3_bucket_name

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true

  depends_on = [
    aws_s3_bucket.cporacle_artifacts
  ]
}