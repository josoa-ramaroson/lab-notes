resource "aws_s3_bucket" "my_bucket" {
  bucket = "devops-cp-5549"
  acl    = "private"

  tags = {
    Name        = "devops-cp-5549"
  }
}

resource "aws_s3_object" "devops_cp_file" {
    bucket = aws_s3_bucket.my_bucket.bucket
    key = "devops.txt"
    source = "/tmp/devops.txt"
}