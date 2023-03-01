# Import variables from the corresponding environment .tfvars file
locals {
  env = var.env
  es_master_name = "${var.env}-es-master"
}