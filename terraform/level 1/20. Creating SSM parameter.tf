resource "aws_ssm_parameter" "nautilus_ssm_parameter" {
    name = "nautilus-ssm-parameter"
    type = "String"
    value = "nautilus-value"
}