resource "aws_ebs_volume" "k8s_volume" {
  availability_zone = "us-east-1a"
  size              = 5
  type              = "gp2"

  tags = {
    Name        = "nautilus-vol"
  }
}

resource "aws_ebs_snapshot" "nautilus_vol_ss" {
    volume_id = aws_ebs_volume.k8s_volume.id
    description = "Nautilus Snapshot"
    tags = {
        Name = "nautilus-vol-ss"
    }
}