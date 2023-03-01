# Use dynamic variables to get the VPC and subnet IDs from the remote state
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.3"
  
  name            = local.es_master_name
  ami             = var.ami
  instance_type   = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_elasticsearch.id]

  iam_instance_profile = aws_iam_instance_profile.ec2-master.name

  # Use dynamic variables to get the VPC ID and subnet IDs from the remote state
  subnet_id       = data.terraform_remote_state.vpc.outputs.vpc.private_subnets[0]

  key_name              = var.key_name
  user_data             = templatefile("userdata/master.sh.tpl", {
    secret_name = "elasticsearch/initial-credentials/${local.es_master_name}"
  })
}

# Define the security group resources
resource "aws_security_group" "ec2_elasticsearch" {
  name_prefix = "${local.es_master_name}-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc.vpc_id

#   # To be added later when there is instances that want to connect
#   ingress {
#     from_port = 9200
#     to_port = 9300
#     protocol = "tcp"
#     security_groups = []
#   }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
