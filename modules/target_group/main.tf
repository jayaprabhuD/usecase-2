# creating target group

resource "aws_lb_target_group" "bayer_tg" {
  name     = "bayer-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.bayer_vpc.id

  health_check {
    path     = "/"
    protocol = "HTTP"
  }

  tags = {
    Name = "bayer-tg"
  }
}

resource "aws_lb_target_group_attachment" "attach_az_1" {
  target_group_arn = aws_lb_target_group.bayer_tg.arn
  target_id        = aws_instance.bayer_frontend_app_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach_az_2" {
  target_group_arn = aws_lb_target_group.bayer_tg.arn
  target_id        = aws_instance.bayer_frontend_app_2.id
  port             = 80
}
