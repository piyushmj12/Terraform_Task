resource "aws_s3_bucket" "westbucket" {
  provider = aws.central
  bucket   = "prachi-west-bucket"
  acl      = "private"

  lifecycle {
    prevent_destroy = false
  }
  #---- lifecycle rule for 1st bucket -----#
  lifecycle_rule {
    id      = "west"
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
resource "aws_kms_key" "westkey" {
  provider                = aws.central
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  multi_region            = true
}
resource "aws_kms_alias" "westkey" {
  provider      = aws.central
  name          = "alias/westkey"
  target_key_id = aws_kms_key.westkey.key_id
}
resource "aws_s3_bucket_server_side_encryption_configuration" "destination_encryption" {
  provider = aws.central
  bucket   = aws_s3_bucket.westbucket.id
  rule {
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.westkey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
resource "aws_s3_bucket_acl" "destination-acl" {
  provider = aws.central
  bucket   = aws_s3_bucket.westbucket.id
  acl      = "private"
}
# Enable versioning for bucket two
resource "aws_s3_bucket_versioning" "westbucket" {
  provider = aws.central
  bucket   = aws_s3_bucket.westbucket.id
  versioning_configuration {
    status = "Enabled"
  }
}