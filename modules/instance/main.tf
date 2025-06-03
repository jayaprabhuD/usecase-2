resource "aws_instance" "app" {
  ami           = "ami-0af9569868786b23a"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data     = var.user_data
  tags = {
    Name = "app-instance"
  }
}

resource "aws_lb_target_group_attachment" "app" {
  target_group_arn = var.tg_arn
  target_id        = aws_instance.app.id
  port             = 80
}
