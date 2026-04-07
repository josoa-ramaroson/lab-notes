output "kke_iam_role_name" {
  value = aws_iam_role.nautilus_role.name
}
output "kke_iam_policy_name" {
  value = aws_iam_policy.nautilus_policy.name
}
