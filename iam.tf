# CREATE IAM ROLE FOR THE REPLICATION RULE
resource "aws_iam_role" "eastiam" {
  name               = "tf-iam-role-replication-east-bucket"
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
resource "aws_iam_policy" "eastiam" {
  name     = "tf-iam-role-policy-replication-east-bucket"
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
        "${aws_s3_bucket.eastbucket.arn}"
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
        "${aws_s3_bucket.eastbucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.westbucket.arn}/*"
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
            "${aws_s3_bucket.eastbucket.arn}/*"
          ]
        }
      },
      "Resource": [
        "${aws_kms_key.eastkey.arn}"
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
            "${aws_s3_bucket.westbucket.arn}/*"
          ]
        }
      },
      "Resource": [
        "${aws_kms_key.westkey.arn}"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eastiam" {
  provider   = aws.source
  role       = aws_iam_role.eastiam.name
  policy_arn = aws_iam_policy.eastiam.arn
}

# CREATE IAM ROLE FOR THE REPLICATION RULE
resource "aws_iam_role" "westiam" {
  name               = "tf-iam-role-replication-west-bucket"
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
resource "aws_iam_policy" "westiam" {
  name     = "tf-iam-role-policy-replication-west-bucket"
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
        "${aws_s3_bucket.westbucket.arn}"
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
        "${aws_s3_bucket.westbucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.eastbucket.arn}/*"
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
            "${aws_s3_bucket.westbucket.arn}/*"
          ]
        }
      },
      "Resource": [
        "${aws_kms_key.westkey.arn}"
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
            "${aws_s3_bucket.eastbucket.arn}/*"
          ]
        }
      },
      "Resource": [
        "${aws_kms_key.eastkey.arn}"
      ]
    }
  ]
}
POLICY
}
resource "aws_iam_role_policy_attachment" "westiam" {
  provider   = aws.central
  role       = aws_iam_role.westiam.name
  policy_arn = aws_iam_policy.westiam.arn
}
