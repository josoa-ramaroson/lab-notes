# inside a directory where the state and terraforma file is located
# executing the command below will recreate a specific resources
terraform plan -replace="aws_instance.web_server"
terraform apply -replace="aws_instance.web_server"