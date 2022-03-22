resource "aws_db_instance" "jumiadb" {
  identifier             = "jumiadb"
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "13.1"
  username               = "postgres"
  password               = var.db_password
  db_subnet_group_name   = var.db_subnet_name
  vpc_security_group_ids = [aws_security_group.main_security_group.id]
  parameter_group_name   = aws_db_parameter_group.jumiadb.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}
resource "aws_db_parameter_group" "jumiadb" {
  name   = "jumiadb"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}
