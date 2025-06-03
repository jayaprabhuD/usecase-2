# 1. Creating security group for ALB
resource "aws_security_group" "bayer_alb_sg" {
  name        = "bayer-alb-sg"
  description = "Allow HTTP"
  vpc_id      = var.bayer_vpc_id

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

# 2. Creating security group for Application Instances
resource "aws_security_group" "bayer_app_sg" {
  name   = "bayer-app-sg"
  vpc_id = var.bayer_vpc_id

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

# 3. Creating security group for Application Instances
resource "aws_security_group" "bayer_rds_sg" {
  name   = "bayer-rds-sg"
  vpc_id = var.bayer_vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.bayer_app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}