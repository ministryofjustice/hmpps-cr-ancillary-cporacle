### Create DB From Scripts

These are the scripts to create a minimal Karma DB for testing.

- Run these against the CPOracle SQL Server Instance - Login as the "Master username' specified in https://eu-west-2.console.aws.amazon.com/rds/home?region=eu-west-2#database:id=cp-oracle-native-backup-restore;is-cluster=false;tab=configuration
- The Password for this user is in SSM Parameter Store in key /cr-unpaid-work-dev/cr/cporacle/rds/rds_master_password (update key name to environment specific keyname)

Run Order

- rds/scripts/CreateDbFromScript/karmadb_1_of_2_schema.sql
- rds/scripts/CreateDbFromScript/karmadb_2_of_2_data.sql
- rds/scripts/CreateDbFromScript/karmadb_create_app_user.sql
- rds/scripts/CreateDbFromScript/karmadb_create_test_users.sql

