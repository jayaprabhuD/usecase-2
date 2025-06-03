output "public_subnet_1_id" {
  value = aws_subnet.bayer_public_subnet_1.id
}

output "public_subnet_2_id" {
  value = aws_subnet.bayer_public_subnet_2.id
}

output "alb_sg_id" {
  value = aws_security_group.bayer_alb_sg.id
}

output "app_sg_id" {
  value = aws_security_group.bayer_app_sg.id
}

output "vpc_id" {
  value = aws_vpc.bayer_vpc.id
}