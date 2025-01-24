resource "aws_instance" "app_ec2" {
  ami           = "ami-08c40ec9ead489470" # Ubuntu 20.04 LTS
  instance_type = var.instance_type
  key_name      = "portfolio"
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_id]

  user_data = var.user_data

  tags = {
    Name = "app-instance"
  }
}

resource "aws_eip_association" "app_ec2" {
  instance_id = aws_instance.app_ec2.id
  public_ip = var.elastic_ip
}

output "instance_public_ip" {
  value = aws_instance.app_ec2.public_ip
}

output "instance_public_dns" {
  value = aws_instance.app_ec2.public_dns
}
