variable "region" {
    description = "region to use"
    default = "eu-west-3"
  
}
variable "vpc_name" {
    description = "vpc name "
    default = "jumia-vpc"
  
}
variable "cluster_name" {
    description = "cluster name"
    default = "jumia-cluster"
  
}
variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
  default = "postgres!2022"
}

variable "db_subnet_name" {
  description = "RDS subnet group name"
  type        = string
  sensitive   = true
  default = "jumiadb_subnet"
}