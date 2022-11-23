resource "aws_s3_bucket" "bucketone" {
  provider = aws.source
  bucket   = "p-tf-test-bucket-01"
  acl      = "private"

  lifecycle {
    prevent_destroy = false
  }
  #---- lifecycle rule for 1st bucket -----#
  lifecycle_rule {
    id      = "archive"
    enabled = true
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }
  tags = { Environment : "Dev" }

}
resource "aws_kms_key" "mykey" {
  provider                = aws.source
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  multi_region            = true
}
resource "aws_kms_alias" "mykey" {
  provider      = aws.source
  name          = "alias/mykey"
  target_key_id = aws_kms_key.mykey.key_id
}
resource "aws_s3_bucket_server_side_encryption_configuration" "source_encryption" {
  bucket   = aws_s3_bucket.bucketone.id
  provider = aws.source
  rule {
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
resource "aws_s3_bucket_acl" "source-acl" {
  provider = aws.source
  bucket   = aws_s3_bucket.bucketone.id
  acl      = "private"
}
# Enable versioning for bucket one
resource "aws_s3_bucket_versioning" "bucketone" {
  provider = aws.source
  bucket   = aws_s3_bucket.bucketone.id
  versioning_configuration {
    status = "Enabled"
  }
}