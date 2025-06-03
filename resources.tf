module "vpc" {
  source = "./modules/vpc"
}

module "security_groups" {
  source     = "./modules/security_groups"
}

module "application_instances" {
 source     = "./modules/application_instances"
}

module "target_group" {
 source      = "./modules/target_group"
}

module "alb" {
  source = "./modules/alb"

  alb_subnet_ids        = [module.bayer_vpc.public_subnet_1_id, module.bayer_vpc.public_subnet_2_id]
  alb_security_group_id = module.bayer_vpc.alb_sg_id
}

module "rds" {
 source      = "./modules/rds"
}