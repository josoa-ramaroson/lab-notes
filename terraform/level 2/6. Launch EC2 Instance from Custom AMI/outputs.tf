output "KKE_ami_id" {
    value = aws_ami_from_instance.devops_ec2_ami.id
}

output "KKE_new_instance_id" {
  value = aws_instance.new_ec2.id
}