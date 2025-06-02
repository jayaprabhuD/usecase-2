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
  source      = "./modules/alb"
}

module "rds" {
  source      = "./modules/rds"
}