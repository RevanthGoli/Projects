# Create S3 Bucket

resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}

# Ownership

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


# Public Block

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Access Control Lists (ACLs)

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

# Index.html

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "index.html"
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}

# Error.html

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "error.html"
  source       = "error.html"
  acl          = "public-read"
  content_type = "text/html"
}

# Profile.png

resource "aws_s3_object" "Profile" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "profile.png"
  source = "profile.png"
  acl    = "public-read"
}

# Website Config Resouce

resource "aws_s3_bucket_website_configuration" "Website" {
  bucket = aws_s3_bucket.mybucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
  depends_on = [aws_s3_bucket_acl.example]
}
