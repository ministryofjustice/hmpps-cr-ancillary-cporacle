
resource "aws_athena_database" "cporacle" {
  name   = local.database_name
  bucket = local.alb_access_logs_s3_bucket
}

resource "aws_athena_workgroup" "cporacle" {
  name = "cporacle"

  configuration {

    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${local.alb_access_logs_s3_bucket}/output/"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }
}