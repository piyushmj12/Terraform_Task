resource "aws_s3_bucket" "eastbucket" {
  provider = aws.source
  bucket   = "prachi-east-bucket"
  acl      = "private"

  lifecycle {
    prevent_destroy = false
  }
  #---- lifecycle rule for 1st bucket -----#
  lifecycle_rule {
    id      = "east"
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
resource "aws_kms_key" "eastkey" {
  provider                = aws.source
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  multi_region            = true
}
resource "aws_kms_alias" "eastkey" {
  provider      = aws.source
  name          = "alias/eastkey"
  target_key_id = aws_kms_key.eastkey.key_id
}
resource "aws_s3_bucket_server_side_encryption_configuration" "source_encryption" {
  bucket   = aws_s3_bucket.eastbucket.id
  provider = aws.source
  rule {
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.eastkey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
resource "aws_s3_bucket_acl" "source-acl" {
  provider = aws.source
  bucket   = aws_s3_bucket.eastbucket.id
  acl      = "private"
}
# Enable versioning for bucket one
resource "aws_s3_bucket_versioning" "eastbucket" {
  provider = aws.source
  bucket   = aws_s3_bucket.eastbucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

