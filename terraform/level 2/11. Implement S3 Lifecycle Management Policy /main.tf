resource "aws_s3_bucket" "devops_lifecycle" {
  bucket = "devops-lifecycle-5634"

  tags = {
    Name        = "devops-lifecycle-5634"
  }
}

resource "aws_s3_bucket_versioning" "devops_lifecycle" {
    bucket = aws_s3_bucket.devops_lifecycle.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_lifecycle_configuration" "devops_lifecycle_rule" {
  bucket = aws_s3_bucket.devops_lifecycle.bucket

  rule {
    id = "devops-lifecycle-rule"
    status = "Enabled"
    filter {
      
    }
    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }
    expiration {
      days = 365
    }
  }
}