module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  subnets         = module.vpc.private_subnets

  tags = {
    Environment = "training"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "worker-node-1"
      instance_type                 = "t2.small"
      additional_userdata           = "Worker node 1"
      asg_desired_capacity          = local.work_node1_size
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      suspended_processes           = ["AZRebalance","Launch","Terminated"]
    },
    {
      name                          = "worker-node-2"
      instance_type                 = "t2.small"
      additional_userdata           = "Worker node 2"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = local.work_node2_size
      suspended_processes           = ["AZRebalance","Launch","Terminated"]
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}