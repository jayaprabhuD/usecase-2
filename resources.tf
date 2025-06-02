# 1. VPC
resource "aws_vpc" "bayer_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "bayer-vpc"
  }
}

# 2. Internet Gateway
resource "aws_internet_gateway" "bayer_igw" {
  vpc_id = aws_vpc.bayer_vpc.id

  tags = {
    Name = "bayer-igw"
  }
}

# 3. Public Subnet 1
resource "aws_subnet" "bayer_public_subnet_1" {
  vpc_id                  = aws_vpc.bayer_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "bayer-public-subnet-1"
  }
}

# 4. Public Subnet 2
resource "aws_subnet" "bayer_public_subnet_2" {
  vpc_id                  = aws_vpc.bayer_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "bayer-public-subnet-2"
  }
}

# 5. Public Subnet 3
resource "aws_subnet" "bayer_public_subnet_3" {
  vpc_id                  = aws_vpc.bayer_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-south-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "bayer-public-subnet-3"
  }
}

# 6. Public Route Table
resource "aws_route_table" "bayer_public_rt" {
  vpc_id = aws_vpc.bayer_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bayer_igw.id
  }

  tags = {
    Name = "bayer-public-route-table"
  }
}

# 7. Associate Subnet 1 with Route Table
resource "aws_route_table_association" "bayer_assoc_subnet_1" {
  subnet_id      = aws_subnet.bayer_public_subnet_1.id
  route_table_id = aws_route_table.bayer_public_rt.id
}

# 8. Associate Subnet 2 with Route Table
resource "aws_route_table_association" "bayer_assoc_subnet_2" {
  subnet_id      = aws_subnet.bayer_public_subnet_2.id
  route_table_id = aws_route_table.bayer_public_rt.id
}

# 9. Associate Subnet 3 with Route Table
resource "aws_route_table_association" "bayer_assoc_subnet_3" {
  subnet_id      = aws_subnet.bayer_public_subnet_3.id
  route_table_id = aws_route_table.bayer_public_rt.id
}

# 10. Creating security group for ALB
resource "aws_security_group" "bayer_alb_sg" {
  name        = "bayer-alb-sg"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.bayer_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 11. Creating security group for Application Instances
resource "aws_security_group" "bayer_app_sg" {
  name   = "bayer-app-sg"
  vpc_id = aws_vpc.bayer_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.bayer_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 12. EC2 Instances with Homepage user_data scripts

resource "aws_instance" "bayer_homepage_app" {
  ami                    = "ami-0af9569868786b23a"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.bayer_public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.bayer_app_sg.id]
  user_data              = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "Hello Verify Homepage :)" > /usr/share/nginx/html/index.html
              echo "Home" > /usr/share/nginx/html/index.html
              echo "<p>Bayer App from Instance A</p>" >> /usr/share/nginx/html/index.html
          EOF

  tags = {
    Name = "Bayer-Homepage-App"
  }
}

#13. EC2 Instances with Image user_data scripts

resource "aws_instance" "bayer_image_app" {
  ami                    = "ami-0af9569868786b23a"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.bayer_public_subnet_2.id
  vpc_security_group_ids = [aws_security_group.bayer_app_sg.id]
  user_data              = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y nginx
              systemctl start nginx
              systemctl enable nginx
              mkdir -p /usr/share/nginx/html/images
              echo "Image" > /usr/share/nginx/html/images/index.html
              echo "<p>Bayer App from Instance B</p>" >> /usr/share/nginx/html/images/index.html
          EOF

  tags = {
    Name = "Bayer-Image-App"
  }
}

# 14. EC2 Instances with Register user_data scripts

resource "aws_instance" "bayer_register_app" {
  ami                    = "ami-0af9569868786b23a"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.bayer_public_subnet_3.id
  vpc_security_group_ids = [aws_security_group.bayer_app_sg.id]
   user_data             = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y nginx
              systemctl start nginx
              systemctl enable nginx
              mkdir -p /usr/share/nginx/html/register
              echo "Register" > /usr/share/nginx/html/register/index.html
              echo "<p>Bayer App from Instance C</p>" >> /usr/share/nginx/html/register/index.html
          EOF
          
tags = {
    Name = "Bayer-Register-App"
  }
}

# Creating ALB Target Group

# resource "aws_lb_target_group" "bayer-alb-tg" {
#   name     = "bayer-app-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.bayer_vpc.id
#   target_type = "instance"
# }

# TG for AZ1 (ec2_az1)
resource "aws_lb_target_group" "bayer_tg_az1" {
  name     = "bayer-tg-az1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.bayer_vpc.id

  health_check {
    path     = "/"
    protocol = "HTTP"
  }

  tags = {
    Name = "bayer-tg-az1"
  }
}

resource "aws_lb_target_group_attachment" "attach_az1" {
  target_group_arn = aws_lb_target_group.bayer_tg_az1.arn
  target_id        = aws_instance.bayer_homepage_app.id
  port             = 80
}


# TG for AZ2 (ec2_az2)
resource "aws_lb_target_group" "bayer_tg_az2" {
  name     = "bayer-tg-az2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.bayer_vpc.id

  health_check {
    path     = "/images"
    protocol = "HTTP"
  }

  tags = {
    Name = "bayer-tg-az2"
  }
}

resource "aws_lb_target_group_attachment" "attach_az2" {
  target_group_arn = aws_lb_target_group.bayer_tg_az2.arn
  target_id        = aws_instance.bayer_image_app.id
  port             = 80
}


# TG for AZ3 (ec2_az3)
resource "aws_lb_target_group" "bayer_tg_az3" {
  name     = "bayer-tg-az3"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.bayer_vpc.id

  health_check {
    path     = "/register"
    protocol = "HTTP"
  }

  tags = {
    Name = "bayer-tg-az3"
  }
}

resource "aws_lb_target_group_attachment" "attach_az3" {
  target_group_arn = aws_lb_target_group.bayer_tg_az3.arn
  target_id        = aws_instance.bayer_register_app.id
  port             = 80
}


# Creating Application Load Balancer

resource "aws_lb" "bayer_alb" {
  name               = "bayer-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.bayer_alb_sg.id]
  subnets            = [
    aws_subnet.bayer_public_subnet_1.id,
    aws_subnet.bayer_public_subnet_2.id,
    aws_subnet.bayer_public_subnet_3.id
  ]
}

# Creating Listener rule for homepage app

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.bayer_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bayer_tg_az1.arn
  }
}

resource "aws_lb_listener_rule" "image" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 8

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bayer_tg_az2.arn
  }

  condition {
    path_pattern {
      values = ["/images/*"]
    }
  }
}

resource "aws_lb_listener_rule" "register" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 15

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bayer_tg_az3.arn
  }

  condition {
    path_pattern {
      values = ["/register/*"]
    }
  }
}