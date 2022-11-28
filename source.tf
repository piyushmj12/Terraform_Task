resource "aws_s3_bucket" "bucketone" {
  bucket = "p-tf-test-bucket-01"
  acl    = "private"

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
  versioning {
    enabled = true
  }
  tags = { Environment : "Dev" }

}

# Enable versioning for bucket one
resource "aws_s3_bucket_versioning" "bucketone" {
  bucket = aws_s3_bucket.bucketone.id
  versioning_configuration {
    status = "Enabled"
  }
}
