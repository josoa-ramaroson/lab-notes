resource "aws_instance" "devops_instance" {
    ami = local.AMI_ID
    instance_type = var.KKE_INSTANCE_TYPE
    key_name = var.KKE_KEY_NAME
    
    count = var.KKE_INSTANCE_COUNT
    tags = {
        Name = "${var.KKE_INSTANCE_PREFIX}-${count.index+1}"
    }
}