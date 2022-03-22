provider "aws" {
  region=var.region
}
resource "aws_vpc" "prod-vpc"  {
    source = "terraform-aws-modules/vpc/aws"
    version = "~>3.0"
    name = var.vpc_name
    cidr = "10.10.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    instance_tenancy = default

    azs = ["${var.region}a","${var.region}b","${var.region}c"]
    public_subnets= ["10.10.0.0/24","10.10.1.0/24","10.10.2.0/24"]
    private_subnets= ["10.10.3.0/24","10.10.4.0/24","10.10.5.0/24"]
    database_subnets= ["10.10.6.0/24","10.10.8.0/24","10.10.9.0/24"]

    create_database_subnet_group =  true
    create_database_subnet_route_table = true
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id = "${aws_vpc.prod-vpc.id}"  
  cidr_block = "10.10.0.0/24"
  map_public_ip_on_launch = true
  availability_zone= "${var.region}a"
  
  tags {
      name = "public-subnet-01"
  }

}


resource "aws_subnet" "public-subnet-2" {
  vpc_id = "${aws_vpc.prod-vpc.id}"  
  cidr_block = "10.10.1.0/24"
  map_public_ip_on_launch = true
  availability_zone= "${var.region}b"
  
  tags {
      name = "public-subnet-02"
  }

}

resource "aws_subnet" "public-subnet-3" {
  vpc_id = "${aws_vpc.prod-vpc.id}"  
  cidr_block = "10.10.3.0/24"
  map_public_ip_on_launch = true
  availability_zone= "${var.region}c"
  
  tags {
      name = "public-subnet-03"
  }

}

resource "aws_subnet" "private-subnet-1" {
  vpc_id = "${aws_vpc.prod-vpc.id}"  
  cidr_block = "10.10.4.0/24"
  map_public_ip_on_launch = false
  availability_zone= "${var.region}a"
  
  tags {
      name = "private-subnet-01"
  }

}

resource "aws_subnet" "private-subnet-2" {
  vpc_id = "${aws_vpc.prod-vpc.id}"  
  cidr_block = "10.10.5.0/24"
  map_public_ip_on_launch = false
  availability_zone= "${var.region}b"
  
  tags {
      name = "private-subnet-02"
  }

}

resource "aws_subnet" "private-subnet-3" {
  vpc_id = "${aws_vpc.prod-vpc.id}"  
  cidr_block = "10.10.6.0/24"
  map_public_ip_on_launch = false
  availability_zone= "${var.region}c"
  
  tags {
      name = "private-subnet-03"
  }

}