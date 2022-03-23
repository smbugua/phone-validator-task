provider "aws" {
  region=var.region
}
locals {
  cluster_name = var.cluster_name
}

#provision vpc
module "vpc" {
   source  = "terraform-aws-modules/vpc/aws"
   version = "3.2.0"
    name = "jumia-vpc"
    cidr = "10.10.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    azs = ["${var.region}a","${var.region}b","${var.region}c"]
    public_subnets= ["10.10.0.0/24","10.10.1.0/24","10.10.2.0/24"]
    private_subnets= ["10.10.3.0/24","10.10.4.0/24","10.10.5.0/24"]
  

     tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

 public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
     name = "private_subnet"
  }
}


#security group 
resource "aws_security_group" "main_security_group" {
    vpc_id = module.vpc.vpc_id
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 1337
        to_port = 1337
        protocol = "tcp"
        // This means, all ip address are allowed to ssh ! 
        cidr_blocks = ["0.0.0.0/0"]
    }
    //If you do not add this rule, you can not reach the NGIX  
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        cidr_blocks = ["10.10.0.0/16"]
    }
    tags = {
        Name = "main-security-group"
    }
}

#create db subnet group
resource "aws_db_subnet_group" "jumiadb_subnet" {
  name       = "jumiadb_subnet"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "jumiadb_subnet"
  }
}
