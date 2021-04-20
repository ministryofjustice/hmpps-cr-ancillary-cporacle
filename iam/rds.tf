#-------------------------------------------------------------
### IAM ROLE FOR RDS
#-------------------------------------------------------------

module "rds_monitoring_role" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//iam//role?ref=terraform-0.12"
  rolename   = "${local.common_name}-rds-monitoring"
  policyfile = "rds_monitoring.json"
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = module.rds_monitoring_role.iamrole_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}


#-------------------------------------------------------------
### IAM Role to allow Import of DB backup from S3
#-
#------------------------------------------------------------------------------------------------

# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/PostgreSQL.Procedural.Importing.html#USER_PostgreSQL.S3Import
#------------------------------------------------------------------------------------------------

# aws iam create-policy \
#    --policy-name rds-s3-import-policy \
#    --policy-document '{
#      "Version": "2012-10-17",
#      "Statement": [
#        {
#          "Sid": "s3import",
#          "Action": [
#            "s3:GetObject",
#            "s3:ListBucket"
#          ],
#          "Effect": "Allow",
#          "Resource": [
#            "arn:aws:s3:::your-s3-bucket", 
#            "arn:aws:s3:::your-s3-bucket/*"
#          ] 
#        }
#      ] 
#    }'  

data "template_file" "cporacle_native_sql_backups_iam_policy" {
  template = file("policies/cporacle_native_sql_backups_iam_policy.tpl")

  vars = {
    s3_bucket    = local.s3_artifact_bucket
  }
}

resource "aws_iam_policy" "cporacle_native_sql_backups_iam_policy" {
  name        = "cporacle-native-sql-backups-iam-role"
  path        = "/"
  description = "CPOracle Policy to Allow RDS to get backup files from S3"
  policy      = data.template_file.cporacle_native_sql_backups_iam_policy.rendered
}

# aws iam create-role \
#    --role-name rds-s3-import-role \
#    --assume-role-policy-document '{
#      "Version": "2012-10-17",
#      "Statement": [
#        {
#          "Effect": "Allow",
#          "Principal": {
#             "Service": "rds.amazonaws.com"
#           },
#          "Action": "sts:AssumeRole"
#        }
#      ] 
#    }'       
resource "aws_iam_role" "cporacle_native_sql_backups_iam_role" {
  name = "cporacle-native-sql-backups-iam-role"

  assume_role_policy = jsonencode({
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Principal": {
            "Service": "rds.amazonaws.com"
          },
         "Action": "sts:AssumeRole"
       }
     ] 
   })

  tags = local.tags
}

# aws iam attach-role-policy \
#    --policy-arn your-policy-arn \
#    --role-name rds-s3-import-role     

resource "aws_iam_role_policy_attachment" "cporacle_native_sql_backups_iam_role" {
  policy_arn = aws_iam_policy.cporacle_native_sql_backups_iam_policy.arn
  role       = aws_iam_role.cporacle_native_sql_backups_iam_role.name
}

# aws rds add-role-to-db-instance \
#    --db-instance-identifier my-db-instance \
#    --feature-name s3Import \
#    --role-arn your-role-arn   \
#    --region your-region