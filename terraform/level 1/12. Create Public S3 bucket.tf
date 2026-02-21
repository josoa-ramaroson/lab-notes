resource "aws_s3_bucket" "devops_s3_25518" {
    bucket = "devops-s3-25518"
    tags = {
        Name = "devops-s3-25518"
    }
}

# resource "aws_s3_bucket_ownership_controls" "devops_s3_25518" {
#     bucket = aws_s3_bucket.devops_s3_25518
#     rule {
#         object_ownershipe = "BucketOwnerPreferred"
#     }
# }

resource "aws_s3_bucket_public_access_block" "devops_s3_25518" {
    bucket = aws_s3_bucket.devops_s3_25518.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false 
    restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "devops_s3_25518" {
    depends_on = [
        # aws_s3_bucket_ownership_controls.devops_s3_25518,
        aws_s3_bucket_public_access_block.devops_s3_25518,
    ]

    bucket = aws_s3_bucket.devops_s3_25518.id 
    acl = "public-read"

}