variable "region" {
  default     = "ap-southeast-1"
  description = "AWS region"
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  cluster_name          = "eks-${random_string.suffix.result}"
  availability_zone     = ["ap-southeast-1a"] #, "ap-southeast-1b", "ap-southeast-1c"]
  work_node1_size       = 1
  work_node2_size       = 0
  private_subnets       = ["10.0.1.0/24"] #, "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets        = ["10.0.4.0/24"] #, "10.0.5.0/24", "10.0.6.0/24"]
}