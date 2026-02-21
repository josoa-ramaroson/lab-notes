resource "aws_s3_bucket" "xfusion_s3_32120" {
    bucket = "xfusion-s3-32120"
    tags = {
        Name = "xfusion-s3-32120"
    }
}

resource "aws_s3_bucket_acl" "xfusion_s3_32120" {
    bucket = aws_s3_bucket.xfusion_s3_32120.id
    acl = "private"
}
