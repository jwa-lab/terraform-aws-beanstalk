resource "aws_s3_bucket" "aws_logs_bucket" {
  bucket = "${var.env_name}-logs-${data.aws_region.current.name}"
  force_destroy = var.production ? false : true
}

resource "aws_s3_bucket_acl" "aws_logs_bucket_acl" {
  bucket = aws_s3_bucket.aws_logs_bucket.id
  acl = "private"
}

resource "aws_s3_bucket_public_access_block" "aws_logs_bucket_public_access_block" {
  bucket = aws_s3_bucket.aws_logs_bucket.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "aws_logs_bucket_policy" {
  bucket = aws_s3_bucket.aws_logs_bucket.id
  policy = data.aws_iam_policy_document.aws_logs_bucket_policy.json
}

data "aws_iam_policy_document" "aws_logs_bucket_policy" {
  statement {
    principals {
      # See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions
      identifiers = [data.aws_elb_service_account.current.arn]
      type = "AWS"
    }
    actions = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.aws_logs_bucket.id}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
  }
}
