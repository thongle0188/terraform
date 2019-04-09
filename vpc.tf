# Select region
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_vpc}"
  enable_dns_hostnames = true
  tags {
    Name = "vpc"
}
}

# Create web subnet
resource "aws_subnet" "web-subnet" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.web_subnet}"
}

# Create db subnet
resource "aws_subnet" "db-subnet" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.db_subnet}"
}

# Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "VPC Gateway"
  }
}

# Route table
resource "aws_route_table" "web-subnet-public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "Public Subnet"
  }
}

# Public web subnet
resource "aws_route_table_association" "web-public" {
  subnet_id = "${aws_subnet.web-subnet.id}"
  route_table_id = "${aws_route_table.web-subnet-public.id}"
}
# Web Security Group
resource "aws_security_group" "web" {
  name = "vpc_web"
  description = "Allow incoming HTTP, HTTPS, SSH"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.db_subnet}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "Web SG"
  }
}

# DB Security Group
resource "aws_security_group" "db" {
  name = "vpc_db"
  description = "Allow traffic from web subnet"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.web_subnet}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.cidr_vpc}"] 
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.cidr_vpc}"]
  }
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "DB SG"
  }
}
