output "kke_sns_topic_name" {
  value = aws_sns_topic.devops.name
}

output "kke_role_name" {
  value = aws_iam_role.devops.name
}

output "kke_policy_name" {
  value = aws_iam_policy.devops.name
}