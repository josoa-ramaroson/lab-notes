resource "aws_s3_bucket" "s3_ran_bucket" {
  bucket = "xfusion-s3-3790"
  acl    = "private"

  tags = {
    Name        = "xfusion-s3-3790"
  }
}

resource "aws_s3_bucket_versioning" "s3_ran_bucket" {
    bucket = aws_s3_bucket.s3_ran_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}