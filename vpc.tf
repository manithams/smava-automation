variable "cluster-name" {
  default = "smava-eks-cluster"
  type = "string"
  }

data "aws_availability_zones" "available" {}

resource "aws_vpc" "smava-eks-vpc" {
  cidr_block = "10.0.0.0/16"
  }

resource "aws_subnet" "smava-az1-subnets" {
  count = 2
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  cidr_block = "10.0.${count.index}.0/24"
  vpc_id = "${aws_vpc.smava-eks-vpc.id}"
}

resource "aws_subnet" "smava-az2-subnets" {
  count = 2
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  cidr_block = "10.0.${count.index}.0/24"
  vpc_id = "${aws_vpc.smava-eks-vpc.id}"
}

