#ElasticSearch EC2 Instance Module

This Terraform module launches EC2 instances in a VPC and Subnet based on the VPC Stack that already been defined.

The module takes the following variables:

- `instance_count`: Number of instances to launch.
- `ami`: ID of the Amazon Machine Image (AMI) to use for the instances.
- `instance_type`: Type of instance to launch (e.g., t2.micro).
- `key_name`: Name of the EC2 key pair to use for SSH access.
- `env`: Environment name for the instances (e.g., dev, prod).
- `data_vpc_s3_bucket`: The bucket of VPC backend configuration

To use this module, include the following code in your Terraform configuration:

