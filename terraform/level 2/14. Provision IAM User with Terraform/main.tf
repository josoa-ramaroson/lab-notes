resource "aws_iam_user" "ravi" {
  name = var.KKE_USER_NAME
  provisioner "local-exec" {
    command = "echo 'KKE iamuser_ravi has been created successfully!' >> KKE_user_created.log"
  }
}