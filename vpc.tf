variable "cluster-name" {
  default = "smava-eks-cluster"
  type = "string"
  }

data "aws_availability_zones" "available" {}

resource "aws_vpc" "smava-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = "${
    map(
      "Name","smava-vpc",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
      )
    }"
  }

resource "aws_subnet" "smava-az1-subnets" {
  count = 2
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  cidr_block = "10.0.${count.index+1}.0/24"
  vpc_id = "${aws_vpc.smava-vpc.id}"
  tags = "${
    map(
      "Name", "smava-subnet-${data.aws_availability_zones.available.names[1]}-${count.index}",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
      )
  }"
}

resource "aws_subnet" "smava-az2-subnets" {
  count = 2
  availability_zone = "${data.aws_availability_zones.available.names[2]}"
  cidr_block = "10.0.${count.index+3}.0/24"
  vpc_id = "${aws_vpc.smava-vpc.id}"
  tags = "${
    map(
      "Name", "smava-subnet-${data.aws_availability_zones.available.names[2]}-${count.index}",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
      )
  }"
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


resource "aws_route_table_association" "smava-rtb-az1-asc-1" {
  subnet_id = "${aws_subnet.smava-az1-subnets.*.id[0]}"
  route_table_id = "${aws_route_table.smava-public-rtb.id}"
}

resource "aws_route_table_association" "smava-rtb-az1-asc-2" {
  subnet_id = "${aws_subnet.smava-az1-subnets.*.id[1]}"
  route_table_id = "${aws_route_table.smava-private-rtb.id}"
}

resource "aws_route_table_association" "smava-rtb-az2-asc-1" {
  subnet_id = "${aws_subnet.smava-az2-subnets.*.id[0]}"
  route_table_id = "${aws_route_table.smava-public-rtb.id}"
}

resource "aws_route_table_association" "smava-rtb-az2-asc-2" {
  subnet_id = "${aws_subnet.smava-az2-subnets.*.id[1]}"
  route_table_id = "${aws_route_table.smava-private-rtb.id}"
}
















































