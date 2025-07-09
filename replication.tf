# PRIMARY S3 Bucket (in us-east-1)


# SECONDARY S3 Bucket (in us-west-1)
resource "aws_s3_bucket" "static_secondary" {
  provider = aws.secondary
  bucket   = "my-static-site-dinesh-secondary"

  tags = {
    Name = "Static Site Secondary"
  }
}

# ✅ Enable versioning on PRIMARY
resource "aws_s3_bucket_versioning" "primary_versioning" {
  provider = aws.primary
  bucket   = aws_s3_bucket.static_primary.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ✅ Enable versioning on SECONDARY
resource "aws_s3_bucket_versioning" "secondary_versioning" {
  provider = aws.secondary
  bucket   = aws_s3_bucket.static_secondary.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ✅ IAM role for replication
resource "aws_iam_role" "replication_role" {
  name = "s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# ✅ IAM policy for replication role
resource "aws_iam_policy" "replication_policy" {
  name = "s3-replication-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ],
        Resource = [aws_s3_bucket.static_primary.arn]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectLegalHold",
          "s3:GetObjectRetention",
          "s3:GetObjectTagging",
          "s3:GetObjectVersionTagging"
        ],
        Resource = ["${aws_s3_bucket.static_primary.arn}/*"]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        Resource = ["${aws_s3_bucket.static_secondary.arn}/*"]
      }
    ]
  })
}

# ✅ Attach policy to the replication role
resource "aws_iam_role_policy_attachment" "replication_attach" {
  role       = aws_iam_role.replication_role.name
  policy_arn = aws_iam_policy.replication_policy.arn
}

# ✅ S3 Replication Configuration
resource "aws_s3_bucket_replication_configuration" "replication" {
  bucket = aws_s3_bucket.static_primary.id
  role   = aws_iam_role.replication_role.arn

  rule {
    id     = "replicate-everything"
    status = "Enabled"

    filter {
      prefix = ""
    }

    delete_marker_replication {
      status = "Disabled"
    }

    destination {
      bucket        = aws_s3_bucket.static_secondary.arn
      storage_class = "STANDARD"
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.primary_versioning,
    aws_s3_bucket_versioning.secondary_versioning,
    aws_iam_role_policy_attachment.replication_attach
  ]
}
