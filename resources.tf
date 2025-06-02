module "vpc" {
  source = "./modules/vpc"
}

#module "alb" {
#  source      = "./modules/alb"
#  vpc_id      = module.vpc.vpc_id
#  subnets     = module.vpc.public_subnets
#  security_groups = [module.sg_group.alb_security_group_id]
#  tg_arns     = [module.tg_a.arn, module.tg_b.arn, module.tg_c.arn]
#}

#module "tg_a" {
#  source      = "./modules/target_group"
#  name        = "tg-a-homepage"
#  port        = 80
#  vpc_id      = module.vpc.vpc_id
#  path        = "/"
#}

#module "tg_b" {
#  source      = "./modules/target_group"
#  name        = "tg-b-image"
#  port        = 80
#  vpc_id      = module.vpc.vpc_id
#  path        = "/image"
#}
#
#module "tg_c" {
#  source      = "./modules/target_group"
#  name        = "tg-c-register"
#  port        = 80
#  vpc_id      = module.vpc.vpc_id
#  path        = "/register"
#}
#
#module "sg_group" {
#  source     = "./modules/sg_group"
#  vpc_id     = module.vpc.vpc_id
#}
#
#
#locals {
#  user_data_home = <<-EOF
#              #!/bin/bash
#              echo "<h1>Welcome to Homepage</h1>" > /var/www/html/index.html
#              yum install -y nginx
#              systemctl start nginx
#              systemctl enable nginx
#              echo "<h1>Home</h1>" > /usr/share/nginx/html/index.html
#              echo "<p>Instance A</p>" >> /usr/share/nginx/html/index.html
#          EOF
#
#  user_data_image = <<-EOF
#              #!/bin/bash
#              yum install -y nginx
#              systemctl start nginx
#              systemctl enable nginx
#              mkdir -p /usr/share/nginx/html/images
#              echo "<h1>Image</h1>" > /usr/share/nginx/html/images/index.html
#              echo "<p>Instance B</p>" >> /usr/share/nginx/html/images/index.html
#          EOF
#
#  user_data_register = <<-EOF
#              #!/bin/bash
#              yum install -y nginx
#              systemctl start nginx
#              systemctl enable nginx
#              mkdir -p /usr/share/nginx/html/register
#              echo "<h1>Register</h1>" > /usr/share/nginx/html/register/index.html
#              echo "<p>Instance C</p>" >> /usr/share/nginx/html/register/index.html
#          EOF
#}
#
#
#module "instances_a" {
#  source          = "./modules/instance"
#  tg_arn          = module.tg_a.arn
#  subnet_id       = module.vpc.public_subnets[0]
#  vpc_security_group_ids = [module.sg_group.ec2_security_group_id]
#  user_data       = local.user_data_home
#  name            = "instance-a"
#}
#
#module "instances_b" {
#  source          = "./modules/instance"
#  tg_arn          = module.tg_b.arn
#  subnet_id       = module.vpc.public_subnets[1]
#  vpc_security_group_ids = [module.sg_group.ec2_security_group_id]
#  user_data       = local.user_data_image
#  name            = "instance-b"
#}
#
#module "instances_c" {
#  source          = "./modules/instance"
#  tg_arn          = module.tg_c.arn
#  subnet_id       = module.vpc.public_subnets[2]
#  vpc_security_group_ids = [module.sg_group.ec2_security_group_id]
#  user_data       = local.user_data_register
#  name            = "instance-c"
#}