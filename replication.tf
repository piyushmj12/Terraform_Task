# REPLICATION CONFIGURATION for one

resource "aws_s3_bucket_replication_configuration" "bucket01_to_bucket02" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.bucketone, aws_s3_bucket.bucketone]

  role   = aws_iam_role.replication01.arn
  bucket = aws_s3_bucket.bucketone.id

  rule {
    id     = "bucket-01"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.buckettwo.arn
      storage_class = "STANDARD"

    }
     }
}

# REPLICATION CONFIG FOR TWO
resource "aws_s3_bucket_replication_configuration" "bucket02_to_bucket01" {
  provider = aws.central
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.buckettwo, aws_s3_bucket.buckettwo]

  role   = aws_iam_role.replication02.arn
  bucket = aws_s3_bucket.buckettwo.id

  rule {
    id = "bucket02"


    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.bucketone.arn
      storage_class = "STANDARD"
    }


  }
}

   
