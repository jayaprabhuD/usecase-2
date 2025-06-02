# Creating Application Load Balancer

resource "aws_lb" "bayer_alb" {
  name               = "bayer-alb-usecase-2"
  internal           = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.bayer_alb_sg.id]
  subnets            = [
    aws_subnet.bayer_public_subnet_1.id,
    aws_subnet.bayer_public_subnet_2.id
  ]
}

# Creating Listener rule for front-end app

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.bayer_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bayer_tg.arn
  }
}