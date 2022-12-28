provider "aws" {
  region = local.region
}

locals {
  region = "eu-west-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "v3.18.1"

  name = "atlantis"

  cidr            = "10.0.0.0/16"
  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway = true
}

module "atlantis" {
  source = "../../"

  name                       = "atlantis"
  ecs_task_cpu               = "1024"
  ecs_task_memory            = "2048"

  network_configuration = {
    vpc_id          = module.vpc.vpc_id
    private_subnets = module.vpc.private_subnets
  }
}
