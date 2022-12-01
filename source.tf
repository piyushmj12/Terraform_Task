resource "aws_s3_bucket" "eastbucket" {
  provider = aws.source
  bucket   = "prachi-east-bucket"
  acl      = "private"

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

#lifecycle configuration

resource "aws_s3_bucket_lifecycle_configuration" "versioning-bucket-config" {
  # Must have bucket versioning enabled first
  provider   = aws.source
  depends_on = [aws_s3_bucket_versioning.eastbucket]
  bucket     = aws_s3_bucket.eastbucket.id
  rule {
    id = "config"
    expiration {
      days = 90
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "GLACIER"
    }

    status = "Enabled"

  }

}