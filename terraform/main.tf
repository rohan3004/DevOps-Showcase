module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr       = "10.0.0.0/16"
  subnet_cidr    = "10.0.1.0/24"
  availability_zones = data.aws_availability_zones.available.names
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source           = "./modules/ec2"
  subnet_id        = module.vpc.subnet_id
  security_group_id = module.security_group.security_group_id
  key_name         = "portfolio"
  instance_type    = var.instance_type 
  EC2_HOST = var.EC2_HOST
}