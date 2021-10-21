module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  subnets         = data.aws_subnet_ids.private.ids

  tags = {
    Environment = "training"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = data.aws_vpc.versent_lab.id

  #Managed Node Groups
  node_groups_defaults = {
    #ami_type  = "AL2_x86_64"
    disk_size = 30
  }

  node_groups = {
    infra = {
      desired_capacity = local.infra_node_size
      max_capacity     = 3
      min_capacity     = 1

      instance_types = ["t2.small"]
      capacity_type  = "ON_DEMAND"
      k8s_labels = {
        Environment = "testing"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
        role        = "infra"
      }
      launch_template_id  = aws_launch_template.infra.id
      #worker_additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
    worker = {
      desired_capacity = local.work_node_size
      max_capacity     = 3
      min_capacity     = 1

      instance_types = ["t2.small"]
      capacity_type  = "ON_DEMAND"
      k8s_labels = {
        Environment = "testing"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
        role        = "worker"
      }
      launch_template_id  = aws_launch_template.worker.id
      #worker_additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
    }
  }
}

resource "aws_launch_template" "infra" {
  name                          = "${local.cluster_name}-infra_launch_template"
  update_default_version        = false

  tag_specifications {
    resource_type               = "instance"
    tags = {
      Name                      = "${local.cluster_name}-infra"
    }   
  }
}

resource "aws_launch_template" "worker" {
  name                          = "${local.cluster_name}-worker_launch_template"
  update_default_version        = false

  tag_specifications {
    resource_type               = "instance"
    tags = {
      Name                      = "${local.cluster_name}-worker"
    }   
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}