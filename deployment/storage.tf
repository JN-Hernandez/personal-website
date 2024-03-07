resource "aws_s3_bucket" "personal_website_s3" {
  bucket = "${var.owner_name}-${var.project}-s3-${var.aws_region}"

  tags = {
    Name    = "${var.owner_name}-${var.project}-s3-${var.aws_region}"
    Project = var.project
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "personal_website_s3_encrypt" {
  bucket = aws_s3_bucket.personal_website_s3.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "personal_website_s3_ownership" {
  bucket = aws_s3_bucket.personal_website_s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "personal_website_s3_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.personal_website_s3_ownership]

  bucket = aws_s3_bucket.personal_website_s3.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "personal_website_s3_website" {
  bucket = aws_s3_bucket.personal_website_s3.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "personal_website_s3_access" {
  bucket = aws_s3_bucket.personal_website_s3.id

  block_public_policy = true
}

resource "aws_s3_bucket_policy" "personal_website_s3_policy" {
  bucket = aws_s3_bucket.personal_website_s3.id
  policy = data.aws_iam_policy_document.personal_website_s3_policy_document.json
}

data "aws_iam_policy_document" "personal_website_s3_policy_document" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["${var.account_id}"]
    }

    sid = "Statement1"
    actions = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.personal_website_s3.arn,
      "${aws_s3_bucket.personal_website_s3.arn}/*",
    ]
  }
}
