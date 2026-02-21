resource "aws_secretsmanager_secret" "nautilus_secret" {
    name = "nautilus-secret"
}

resource "aws_secretsmanager_secret_version" "nautilus_secret" {
    secret_id = aws_secretsmanager_secret.nautilus_secret.id
    secret_string = jsonencode({
        "username": "admin",
        "password": "Namin123"
    })
}

# or 
variable "secrets_to_store" {
    default = {
        "username": "admin",
        "password": "Namin123"
    }

    type = map(string)
}

resource "aws_secretsmanager_secret_version" "nautilus_secret" {
    secret_id = aws_secretsmanager_secret.nautilus_secret.id
    secret_string = jsonencode(var.secrets_to_store)
}
