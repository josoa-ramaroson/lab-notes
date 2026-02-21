# Get availability zones in us-east-1

data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_ebs_volume" "example" {
    availability_zone = data.aws_availability_zones.available.names[0]
    size = 2
    type = "gp3" 
    tags = {
        Name = "datacenter-volume"
    }
}