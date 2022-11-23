resource "aws_s3_bucket" "buckettwo" {
  provider = aws.central
  bucket   = "p-tf-test-bucket-02"
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
resource "aws_kms_key" "prachikey" {
  provider                = aws.central
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  multi_region            = true
}
resource "aws_kms_alias" "prachikey" {
  provider      = aws.central
  name          = "alias/prachikey"
  target_key_id = aws_kms_key.prachikey.key_id
}
resource "aws_s3_bucket_server_side_encryption_configuration" "destination_encryption" {
  provider = aws.central
  bucket   = aws_s3_bucket.buckettwo.id
  rule {
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.prachikey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
resource "aws_s3_bucket_acl" "destination-acl" {
  provider = aws.central
  bucket   = aws_s3_bucket.buckettwo.id
  acl      = "private"
}
# Enable versioning for bucket two
resource "aws_s3_bucket_versioning" "buckettwo" {
  provider = aws.central
  bucket   = aws_s3_bucket.buckettwo.id
  versioning_configuration {
    status = "Enabled"
  }
}