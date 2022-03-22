resource "aws_rds_cluster" "jumiadb" {
  cluster_identifier     = "jumiadb"
  db_cluster_instance_class = "db.t3.micro"
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "13.3"
  master_username               = "postgres"
  master_password               = var.db_password
  db_subnet_group_name   = var.db_subnet_name
  vpc_security_group_ids = [aws_security_group.main_security_group.id]
  skip_final_snapshot    = true
}
