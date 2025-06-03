# 1. Creating EC2 Instances front-end application

resource "aws_instance" "bayer_frontend_app_1" {
  ami                    = "ami-0af9569868786b23a"
  instance_type          = "t2.micro"
  subnet_id              = var.instance_1_subnet_id
  vpc_security_group_ids = var.app_sg_id
  user_data              = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "Hello Verify Homepage :)" > /usr/share/nginx/html/index.html
              echo "Welcome to Bayer front-end app from AZ-1" > /usr/share/nginx/html/index.html
          EOF

  tags = {
    Name = "Bayer-Front-end-App-1"
  }
}

# 2. Creating EC2 Instances front-end application

resource "aws_instance" "bayer_frontend_app_2" {
  ami                    = "ami-0af9569868786b23a"
  instance_type          = "t2.micro"
  subnet_id              = var.instance_2_subnet_id
  vpc_security_group_ids = var.app_sg_id
  user_data              = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "Hello Verify Homepage :)" > /usr/share/nginx/html/index.html
              echo "Welcome to Bayer front-end app from AZ-2" > /usr/share/nginx/html/index.html
          EOF

  tags = {
    Name = "Bayer-Front-end-App-2"
  }
}