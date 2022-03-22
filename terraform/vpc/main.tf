provider "aws" {
  region=var.region
}

#provision vpc
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

#provision subnets
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


#provision ig

resource "aws_internet_gateway" "prod-igw" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    tags {
        Name = "prod-igw"
    }
}



#provision route table
resource "aws_route_table" "prod-public-crt" {
    vpc_id = "${aws_vpc.main-vpc.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.prod-igw.id}" 
    }
    
    tags {
        Name = "prod-public-crt"
    }
}

#assouciate my route table with public subnets
resource "aws_route_table_association" "prod-crta-public-subnet-1"{
    subnet_id = "${aws_subnet.public-subnet-1.id}"
    route_table_id = "${aws_route_table.prod-public-crt.id}"
}


resource "aws_route_table_association" "prod-crta-public-subnet-2"{
    subnet_id = "${aws_subnet.public-subnet-2.id}"
    route_table_id = "${aws_route_table.prod-public-crt.id}"
}


resource "aws_route_table_association" "prod-crta-public-subnet-3"{
    subnet_id = "${aws_subnet.public-subnet-2.id}"
    route_table_id = "${aws_route_table.prod-public-crt.id}"
}

#security group 
resource "aws_security_group" "main_security_group" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    
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
    tags {
        Name = "ssh-allowed"
    }
}

