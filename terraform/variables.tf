variable "aws_region" {
  default = "us-east-1"
}

variable "key_name" {
  description = "Key Pair for EC2 Access"
  default     = "my-key-pair"
}

variable "ssh_public_key" {
  type        = string
  description = "Public SSH key for EC2"
}

variable "instance_type" {
  default = "t2.micro"
}
