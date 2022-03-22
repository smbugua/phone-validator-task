provider "aws" {
  region=var.region
}
module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "~>3.0"
    name = var.vpc_name
    cidr = "10.10.0.0/16"

    azs = ["${var.region}a","${var.region}b","${var.region}c"]
    public_subnets= ["10.10.0.0/24","10.10.1.0/24","10.10.2.0/24"]
    private_subnets= ["10.10.3.0/24","10.10.4.0/24","10.10.5.0/24"]
    database_subnets= ["10.10.6.0/24","10.10.8.0/24","10.10.9.0/24"]

    create_database_subnet_group =  true
    create_database_subnet_route_table = true
   
}


