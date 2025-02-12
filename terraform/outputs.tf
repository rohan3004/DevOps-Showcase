output "ec2_public_ip" {
  value = module.ec2.instance_public_ip
}

output "ssh_access" {
  value = "ssh -i ~/portfolio.pem ubuntu@${module.ec2.instance_public_ip}"
}

output "ec2_public_dns" {
  value = module.ec2.instance_public_dns
}
