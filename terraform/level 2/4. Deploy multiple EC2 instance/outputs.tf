output "kke_instance_names" {
    value = [for instance in aws_instance.devops_instance : instance.tags["Name"]]
}