resource "random_string" "random" {
  length           = 6
  special          = true
  override_special = "-"
  lower = true
  upper = false
}


resource "aws_s3_bucket" "geo-bucket" {
  bucket_prefix = "${var.geo-bucket-prefix}-${random_string.random.result}"
}

resource "aws_kms_key" "poc-key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "geo-server" {
  bucket = aws_s3_bucket.geo-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.poc-key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


#Block public access
resource "aws_s3_bucket_public_access_block" "s3Public" {
  depends_on = [aws_s3_bucket.geo-bucket]
  bucket                  = aws_s3_bucket.geo-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


#Create Bucket Policy Document
data "aws_iam_policy_document" "geo-access-policy-s3-document" {
    statement {
            effect  = "Allow"
            actions = ["s3:PutObject"]
            resources = ["arn:aws:s3:::${aws_s3_bucket.geo-bucket.id}/*",
			                   "arn:aws:s3:::${aws_s3_bucket.geo-bucket.id}"]
            principals {
                type = "AWS"
                identifiers = ["*"]
            }
            condition {
              test     = "StringEquals"
              variable = "s3:x-amz-acl"
              values = [
                  "bucket-owner-full-control"
              ]
            }

            
  } 
   statement {
            effect  = "Allow"
            actions = ["s3:ListBucket", 
                       "s3:GetObject"
                      ]
            resources = ["arn:aws:s3:::${aws_s3_bucket.geo-bucket.id}/*",
			                   "arn:aws:s3:::${aws_s3_bucket.geo-bucket.id}"]
            principals {
                type = "AWS"
                identifiers = ["*"]
            }
  }  
   
}

#Create Bucket Policy
resource "aws_s3_bucket_policy" "geo-access-policy-users" {
  bucket = aws_s3_bucket.geo-bucket.id
  policy = data.aws_iam_policy_document.geo-access-policy-s3-document.json
}


