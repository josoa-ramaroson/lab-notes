resource "aws_s3_bucket" "wordpress_bucket" {
  bucket = "xfusion-s3-13383"
}

resource "aws_s3_bucket_acl" "wordpress_bucket_acl" {
  bucket = aws_s3_bucket.wordpress_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket" "xfusion_bucket" {
  bucket = var.KKE_BUCKET
    tags = {
      Names = var.KKE_BUCKET
    }
}

resource "aws_s3_bucket_acl" "xfusion_bucket_acl" {
  bucket = aws_s3_bucket.xfusion_bucket.id
  acl = "private"
}

resource "null_resource" "s3_sync" {
  depends_on = [ aws_s3_bucket.wordpress_bucket, aws_s3_bucket.xfusion_bucket ]

  provisioner "local-exec" {
    command = "aws s3 sync s3://${aws_s3_bucket.wordpress_bucket.bucket} s3://${aws_s3_bucket.xfusion_bucket.bucket} --delete"
  }
}