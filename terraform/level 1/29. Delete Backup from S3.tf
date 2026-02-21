
resource "null_resource" "run_aws_cli" {
    provisioner "local-exec" {
        command = "aws s3 cp s3://devops-bck-23288 /opt/s3-backup/ --recursive && aws s3 rb s3://devops-bck-23288 --force"
    }
}