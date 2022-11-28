resource "aws_s3_bucket" "buckettwo" {
  provider = aws.central
  bucket   = "p-tf-test-bucket-02"
  acl      = "private"

  lifecycle {
    ignore_changes = [
      server_side_encryption_configuration,
      replication_configuration,
    ]
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
# Enable versioning for bucket two
resource "aws_s3_bucket_versioning" "buckettwo" {
  provider = aws.central
  bucket   = aws_s3_bucket.buckettwo.id
  versioning_configuration {
    status = "Enabled"
  }
}
