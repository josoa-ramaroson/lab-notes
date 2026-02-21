resource "tls_private_key" "rsa-pk" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "datacenter-kp" {
    key_name = "datacenter-kp"
    public_key = tls_private_key.rsa-pk.public_key_openssh
}

resource "local_file" "datacenter-kp" {
    filename = "/home/bob/datacenter-kp.pem"
    content = tls_private_key.rsa-pk.private_key_pem
    file_permission = "0400"
}