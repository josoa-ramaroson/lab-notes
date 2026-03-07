    output "KKE_instance_name" {
    value = aws_instance.datacenter_ec2.tags["Name"] 
    }
    output "KKE_eip" {
        value = aws_eip.datacenter_eip.public_ip
    }