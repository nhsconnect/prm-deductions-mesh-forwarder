resource "aws_s3_bucket" "mesh-temp-destination" {
  bucket = "${var.component_name}-${var.environment}-mesh-temp-destination"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "temp_bucket" {
  bucket = aws_s3_bucket.mesh-temp-destination.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_role_policy_attachment" "s3_bucket_access" {
  role       = aws_iam_role.mesh_forwarder.name
  policy_arn = aws_iam_policy.temp_bucket_access.arn
}

resource "aws_iam_policy" "temp_bucket_access" {
  name   = "${aws_s3_bucket.mesh-temp-destination.bucket}-bucket-access"
  policy = data.aws_iam_policy_document.temp_bucket_access.json
}

data "aws_iam_policy_document" "temp_bucket_access" {
  statement {
    sid = "ListObjectsInBucket"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.mesh-temp-destination.bucket}",
    ]
  }

  statement {
    sid = "AllObjectActions"

    actions = [
      "s3:*Object"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.mesh-temp-destination.bucket}/*",
    ]
  }
}