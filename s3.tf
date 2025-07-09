# Primary S3 Bucket
resource "aws_s3_bucket" "static_primary" {
  provider = aws.primary
  bucket   = "my-static-site-dinesh-primary"

  tags = {
    Name = "Primary Static Website"
  }
}

# Unblock public access settings
resource "aws_s3_bucket_public_access_block" "primary" {
  provider                = aws.primary
  bucket                  = aws_s3_bucket.static_primary.id
  block_public_acls       = false
  block_public_policy     = false
  restrict_public_buckets = false
  ignore_public_acls      = false
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "static_primary" {
  provider = aws.primary
  bucket   = aws_s3_bucket.static_primary.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Make bucket publicly readable via ACL
resource "aws_s3_bucket_acl" "primary_acl" {
  provider = aws.primary
  bucket   = aws_s3_bucket.static_primary.bucket
  acl      = "public-read"

  depends_on = [aws_s3_bucket_public_access_block.primary]
}

# Allow public access to website content
resource "aws_s3_bucket_policy" "primary_policy" {
  provider = aws.primary
  bucket   = aws_s3_bucket.static_primary.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject"
        ],
        Resource = "${aws_s3_bucket.static_primary.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.primary]
}
