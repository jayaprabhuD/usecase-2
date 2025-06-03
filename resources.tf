module "vpc" {
  source = "./modules/vpc"
  vpc_id = var.bayer_vpc_id
}

module "security_groups" {
  source     = "./modules/security_groups"
  vpc_id = module.vpc.bayer_vpc_id
}

module "application_instances" {
  source     = "./modules/application_instances"
 
  instance_1_subnet_id = module.vpc.public_subnet_1_id
  instance_2_subnet_id = module.vpc.public_subnet_2_id
  app_security_group_id = module.vpc.app_sg_id
}

module "target_group" {
 source      = "./modules/target_group"
}

module "alb" {
  source = "./modules/alb"

  alb_subnet_ids        = [module.vpc.public_subnet_1_id, module.vpc.public_subnet_2_id]
  alb_security_group_id = module.vpc.alb_sg_id
  target_group_arn      = [module.target_group.target_group_arn]
 }

module "rds" {
 source      = "./modules/rds"

 rds_subnet_ids        = [module.vpc.private_subnet_1_id, module.vpc.private_subnet_2_id]
 rds_security_group_id = module.vpc.rds_sg_id
}