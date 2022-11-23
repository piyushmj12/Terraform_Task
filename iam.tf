# CREATE IAM ROLE FOR THE REPLICATION RULE
resource "aws_iam_role" "replication01" {
  name               = "tf-iam-role-replication-bucket-01"
  provider           = aws.source
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}
resource "aws_iam_policy" "replication01" {
  name     = "tf-iam-role-policy-replication-bucket-01"
  provider = aws.source
  policy   = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.bucketone.arn}"
      ]
    },
    {
      "Action": [
        "s3: GetObjectVersion",
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl",
         "s3:GetObjectVersionTagging"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.bucketone.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.buckettwo.arn}/*"
    },
    {
      "Action": [
        "kms:Decrypt"
      ],
      "Effect": "Allow",
      "Condition": {
        "StringLike": {
          "kms:ViaService": "s3.eu-west-1.amazonaws.com",
          "kms:EncryptionContext:aws:s3:arn": [
            "${aws_s3_bucket.bucketone.arn}"
          ]
        }
      },
      "Resource": [
        "${aws_kms_key.mykey.arn}"
      ]
    },
    {
      "Action": [
        "kms:Encrypt"
      ],
      "Effect": "Allow",
      "Condition": {
        "StringLike": {
          "kms:ViaService": "s3.eu-central-1.amazonaws.com",
          "kms:EncryptionContext:aws:s3:arn": [
            "${aws_s3_bucket.buckettwo.arn}"
          ]
        }
      },
      "Resource": [
        "${aws_kms_key.prachikey.arn}"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "replication01" {
  provider   = aws.source
  role       = aws_iam_role.replication01.name
  policy_arn = aws_iam_policy.replication01.arn
}

# CREATE IAM ROLE FOR THE REPLICATION RULE
resource "aws_iam_role" "replication02" {
  name               = "tf-iam-role-replication-bucket-02"
  provider           = aws.central
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}
resource "aws_iam_policy" "replication02" {
  name     = "tf-iam-role-policy-replication-bucket-02"
  provider = aws.central
  policy   = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.buckettwo.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl",
         "s3:GetObjectVersionTagging"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.buckettwo.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.bucketone.arn}/*"
    },
    {
      "Action": [
        "kms:Decrypt"
      ],
      "Effect": "Allow",
      "Condition": {
        "StringLike": {
          "kms:ViaService": "s3.eu-central-1.amazonaws.com",
          "kms:EncryptionContext:aws:s3:arn": [
            "${aws_s3_bucket.buckettwo.arn}"
          ]
        }
      },
      "Resource": [
        "${aws_kms_key.prachikey.arn}"
      ]
    },
    {
      "Action": [
        "kms:Encrypt"
      ],
      "Effect": "Allow",
      "Condition": {
        "StringLike": {
          "kms:ViaService": "s3.eu-west-1.amazonaws.com",
          "kms:EncryptionContext:aws:s3:arn": [
            "${aws_s3_bucket.bucketone.arn}"
          ]
        }
      },
      "Resource": [
        "${aws_kms_key.mykey.arn}"
      ]
    }
  ]
}
POLICY
}
resource "aws_iam_role_policy_attachment" "replication02" {
  provider   = aws.central
  role       = aws_iam_role.replication02.name
  policy_arn = aws_iam_policy.replication02.arn
}
