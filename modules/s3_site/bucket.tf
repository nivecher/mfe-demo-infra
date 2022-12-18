resource "aws_s3_bucket" "site_bucket" {
  bucket = var.domain
  /* region = "us-east-2"
  /* acl = "private" # Will be read only through cloudfront */

  /* website {
    index_document = "index.html"
    error_document = "index.html"
  }
  cors_rule {
    allowed_origins = "${var.all_domains}"
    allowed_methods = ["GET", "HEAD"]
  } */
  /* versioning {
    enabled = true
  } */
}

resource "aws_s3_bucket_website_configuration" "site_website_config" {
  bucket = aws_s3_bucket.site_bucket.id
}

resource "aws_s3_bucket_versioning" "site_bucket_versioning" {
  bucket = aws_s3_bucket.site_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "site_bucket_acl" {
  bucket = aws_s3_bucket.site_bucket.id
}

resource "aws_s3_bucket_policy" "site_bucket_policy" {
  bucket = aws_s3_bucket.site_bucket.id
  policy = data.aws_iam_policy_document.cloudfront_get_from_s3.json
}

data "aws_iam_policy_document" "cloudfront_get_from_s3" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.site_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.cloudfront_access.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.site_bucket.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.cloudfront_access.iam_arn}"]
    }
  }
}
