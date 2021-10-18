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
  cluster_name        = "versentsg-ekslab-${random_string.suffix.result}"
  availability_zone   = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}