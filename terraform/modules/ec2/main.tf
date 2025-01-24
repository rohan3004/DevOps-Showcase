resource "aws_key_pair" "app_key" {
  key_name   = var.key_name
  public_key = var.ssh_public_key
}

resource "aws_instance" "app_ec2" {
  ami           = "ami-08c40ec9ead489470" # Ubuntu 20.04 LTS
  instance_type = var.instance_type
  key_name      = aws_key_pair.app_key.key_name
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_id]

  user_data = var.user_data

  tags = {
    Name = "app-instance"
  }
}

output "instance_public_ip" {
  value = aws_instance.app_ec2.public_ip
}

output "instance_public_dns" {
  value = aws_instance.app_ec2.public_dns
}
