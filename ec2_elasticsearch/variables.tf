variable "instance_count" {
  type        = number
  description = "Number of instances to launch"
}

variable "ami" {
  type        = string
  description = "ID of the Amazon Machine Image (AMI) to use for the instances"
}

variable "instance_type" {
  type        = string
  description = "Type of instance to launch (e.g., t2.micro)"
}

variable "key_name" {
  type        = string
  description = "Name of the EC2 key pair to use for SSH access"
}

variable "env" {
  type        = string
  description = "Environment name for the instances (e.g., dev, prod)"
}

variable "data_vpc_s3_bucket" {
  type        = string
  description = "The bucket of VPC backend configuration"
}
