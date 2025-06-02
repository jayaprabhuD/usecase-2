# Creating RDS Subnet Group

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "Bayer-rds-subnet-group"
  subnet_ids = [
    aws_subnet.bayer_private_subnet_1.id,
    aws_subnet.bayer_private_subnet_2.id
  ]

  tags = {
    Name = "Bayer RDS Subnet Group"
  }
}


# RDS MySQL Instance
resource "aws_db_instance" "mysql" {
  identifier              = "bayer-mysql-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  storage_type            = "gp2"
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.bayer_rds_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false
  backup_retention_period = 7

  tags = {
    Name = "Bayer-MySQL-RDS"
  }
}
