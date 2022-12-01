# REPLICATION CONFIGURATION for one

resource "aws_s3_bucket_replication_configuration" "bucket01_to_bucket02" {
  # Must have bucket versioning enabled first
  provider   = aws.source
  depends_on = [aws_s3_bucket_versioning.eastbucket, aws_s3_bucket.eastbucket]
  // acl = "private"
  role   = aws_iam_role.eastiam.arn
  bucket = aws_s3_bucket.eastbucket.id

  rule {
    id     = "bucket-01"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.westbucket.arn
      storage_class = "STANDARD"
      encryption_configuration {
        replica_kms_key_id = aws_kms_key.westkey.arn

      }
    }
    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }
  }
}
# REPLICATION CONFIG FOR TWO
resource "aws_s3_bucket_replication_configuration" "bucket02_to_bucket01" {
  provider = aws.central
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.westbucket, aws_s3_bucket.westbucket]

  role   = aws_iam_role.westiam.arn
  bucket = aws_s3_bucket.westbucket.id

  rule {
    id = "bucket02"


    status = "Enabled"

    destination {
      bucket = aws_s3_bucket.eastbucket.arn
      encryption_configuration {
        replica_kms_key_id = aws_kms_key.eastkey.arn

      }
      storage_class = "STANDARD"
    }
    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }

  }
}   