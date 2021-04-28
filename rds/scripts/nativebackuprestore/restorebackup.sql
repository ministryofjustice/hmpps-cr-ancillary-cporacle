-- Restoring the full backup to Amazon RDS

-- After setting up the IAM role and option group, you can start the restore process. With the backup schedule scenario defined earlier, this is a backup taken on Saturday at 9:00 PM.

-- Amazon S3 has a size limit of 5 TB per file. For native backups of larger databases, you can use a multi-file backup on the source instance.

-- Run the following Amazon RDS restore procedures in SQL Server Management Studio:

use master
go

exec msdb.dbo.rds_restore_database
    @restore_db_name='mydatabase',
    @s3_arn_to_restore_from='arn:aws:s3:::tf-eu-west-2-hmpps-eng-dev-artefacts-cporacle-s3bucket/sqlserverbackups/mydb_full-1.bak',
    @with_norecovery=1,
    @type='FULL';
go

-- The preceding restore task uses the NORECOVERY option by specifying @with_norecovery=1. The database is left in the RESTORING state, allowing for subsequent differential or log restores.

-- You can check the status of the restore task with the following code:

use master
go
select * from msdb.dbo.rds_fn_task_status(null,0) 
go

-- The restore process is complete when the lifecycle shows SUCCESS and percentage complete is 100.

