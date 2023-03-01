data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "${var.data_vpc_s3_bucket}"
    key    = "env:/${local.env}/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}