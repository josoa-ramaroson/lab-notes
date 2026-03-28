resource "aws_s3_bucket" "xfusion_s3_20863" {
  bucket = var.KKE_BUCKET_NAME
  tags = {
    Name =  var.KKE_BUCKET_NAME
  }
  lifecycle {
    prevent_destroy = true
  }
}

