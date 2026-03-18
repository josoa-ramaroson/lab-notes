output "new_kke_bucket_name" {
  value = aws_s3_bucket.xfusion_bucket.bucket

}
output "new_kke_bucket_acl" {
  value = aws_s3_bucket_acl.xfusion_bucket_acl.acl
}