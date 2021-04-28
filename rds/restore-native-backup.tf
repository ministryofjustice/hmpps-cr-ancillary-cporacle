
# Full Docs at:
# https://aws.amazon.com/blogs/database/migrating-sql-server-to-amazon-rds-using-native-backup-and-restore/

#------------------------------------------------------------------------------------------------------
# Creating an IAM policy and role
# We have included a sample policy in this post for reference. Create a new role with this policy and add trust for Amazon RDS to assume this role.
#------------------------------------------------------------------------------------------------------

# {
#     "Version": "2012-10-17",
#     "Statement":
#     [
#         {
#             "Effect": "Allow",
#             "Action": [ 
#                 "s3:ListBucket", 
#                 "s3:GetBucketLocation"
#             ],
#             "Resource": "arn:aws:s3:::bucket_name"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [ 
#                 "s3:GetObject", 
#                 "s3:PutObject", 
#                 "s3:ListMultipartUploadParts", 
#                 "s3:AbortMultipartUpload"
#             ],
#             "Resource": "arn:aws:s3:::bucket_name/*"
#         }
#     ]
# }

#------------------------------------------------------------------------------------------------------
# Adding trust for Amazon RDS to assume the role
# When you create an IAM role, you attach a trust relationship and a permissions policy. 
# The trust relationship allows Amazon RDS to assume this role. See the following code:
#------------------------------------------------------------------------------------------------------

# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Principal": {"Service": "rds.amazonaws.com"},
#             "Action": "sts:AssumeRole"
#         }
#     ]
# }

#------------------------------------------------------------------------------------------------------
# Adding an option group for backup and restore
#------------------------------------------------------------------------------------------------------

# Option groups in Amazon RDS provide flexibility to manage additional features. In this post, we add an option for native backup and restore. For a full list of available options, see Options for the Microsoft SQL Server database engine.

# You can create a new option group if it doesn’t exist and then add an option SQLSERVER_BACKUP_RESTORE to that option group. Complete the following steps:

#     On the Amazon RDS console, choose Option Groups in the navigation pane.
#     Choose Create Group.
#     Enter the name, description, engine, and engine version of your server.
#     Choose Create.
#     Select the option group that you created, and choose Add Option.
#     Choose SQLSERVER_BACKUP_RESTORE.
#     Choose the IAM Role created in the earlier step.
#     Choose Immediately.
#     Choose Add Option.
#     Associate the option group with the DB instance by choosing Databases in the navigation pane.
#     Choose the target RDS SQL Server instance
#     On the Actions menu, choose Modify.
#     Under Database Options, choose the option group that you created.
#     Choose Continue.
#     Choose Apply Immediately.
#     Review the information and choose Modify DB Instance.

# This option group modification has no downtime because an instance reboot is not required.

#------------------------------------------------------------------------------------------------------
# Restoring the full backup to Amazon RDS
#------------------------------------------------------------------------------------------------------

# After setting up the IAM role and option group, you can start the restore process. With the backup schedule scenario defined earlier, this is a backup taken on Saturday at 9:00 PM.

# Amazon S3 has a size limit of 5 TB per file. For native backups of larger databases, you can use a multi-file backup on the source instance.

# Run the following Amazon RDS restore procedures in SQL Server Management Studio:

# See rds/scripts/nativebackuprestore/restorebackup.sql