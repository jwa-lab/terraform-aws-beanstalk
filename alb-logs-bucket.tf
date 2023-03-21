resource "aws_s3_bucket" "alb_logs_bucket" {
  count = var.alb_logs ? 1 : 0

  bucket = "${var.env_name}-alb-logs"
  force_destroy = var.production ? false : true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "alb_logs_bucket_encryption" {
  count = var.alb_logs ? 1 : 0

  bucket = aws_s3_bucket.alb_logs_bucket[0].id
  expected_bucket_owner = local.account_id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "alb_logs_bucket_pab" {
  count = var.alb_logs ? 1 : 0

  bucket = aws_s3_bucket.alb_logs_bucket[0].id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "alb_logs_bucket_policy" {
  count = var.alb_logs ? 1 : 0

  bucket = aws_s3_bucket.alb_logs_bucket[0].id
  policy = data.aws_iam_policy_document.alb_logs_bucket_policy[0].json
}

# see https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html#attach-bucket-policy
data "aws_iam_policy_document" "alb_logs_bucket_policy" {
  count = var.alb_logs ? 1 : 0

  statement {
    sid = "ALBAllowWriteLogs"
    principals {
      identifiers = [data.aws_elb_service_account.current.arn]
      type = "AWS"
    }
    actions = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.alb_logs_bucket[0].arn}/AWSLogs/${local.account_id}/*"]
  }
}

# Versioning should not be needed as ALB will never update or overwrite files
# but it allows to ensure that the log files have not been altered
resource "aws_s3_bucket_versioning" "alb_logs_bucket_versioning" {
  count = var.alb_logs ? 1 : 0

  bucket = aws_s3_bucket.alb_logs_bucket[0].id
  expected_bucket_owner = local.account_id

  versioning_configuration {
    status = "Enabled"
  }
}
