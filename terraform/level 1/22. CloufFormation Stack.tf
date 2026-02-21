resource "aws_cloudformation_stack" "datacenter_stack" {
    name = "datacenter-stack"

    template_body = jsonencode({
        Resources = {
            XFusionStackBucket = {
                Type: "AWS::S3::Bucket"
                Properties = {
                    BucketName = "datacenter-bucket-7130"
                    VersioningConfiguration = {
                        Status: "Enabled"
                    }
                }
            }
        }
    })
}