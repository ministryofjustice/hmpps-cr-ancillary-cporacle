{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Sid": "s3import",
        "Action": [
            "s3:GetObject",
            "s3:ListBucket"
        ],
        "Effect": "Allow",
        "Resource": [
            "arn:aws:s3:::${s3_bucket}", 
            "arn:aws:s3:::${s3_bucket}/*"
        ] 
    }
    ] 
}