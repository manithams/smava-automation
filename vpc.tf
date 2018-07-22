variable "cluster-name" {
  default = "smava-eks-cluster"
  type = "string"
  }

data "aws_availability_zones" "available" {}

resource "aws_vpc" "smava-vpc" {
  cidr_block = "20.0.0.0/16"
  }

resource "aws_subnet" "smava-az1-subnets" {
  count = 2
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  cidr_block = "20.0.${count.index+1}.0/24"
  vpc_id = "${aws_vpc.smava-vpc.id}"
}

resource "aws_subnet" "smava-az2-subnets" {
  count = 2
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  cidr_block = "20.0.${count.index+3}.0/24"
  vpc_id = "${aws_vpc.smava-vpc.id}"
}

resource "aws_internet_gateway" "smava-igw" {
  vpc_id = "${aws_vpc.smava-vpc.id}"
  tags {
    Name = "smava-igw"
  }
}

resource "aws_eip" "smava-ngw-eip" {}

resource "aws_nat_gateway" "smava-ngw" {
  allocation_id = "${aws_eip.smava-ngw-eip.id}"
  subnet_id     = "${aws_subnet.smava-az1-subnets.*.id[0]}"
  tags {
  Name = "smava-ngw"
  }
}

resource "aws_route_table" "smava-public-rtb" {
  vpc_id = "${aws_vpc.smava-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.smava-igw.id}"
    }
    tags {
    Name = "smava-public-rtb"
    }
}

resource "aws_route_table" "smava-private-rtb" {
  vpc_id = "${aws_vpc.smava-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.smava-ngw.id}"
    }

    tags {
      Name = "smava-private-rtb"
      }
}


































