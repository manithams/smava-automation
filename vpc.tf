variable "cluster-name" {
  default = "smava-eks-cluster"
  type = "string"
  }

data "aws_availability_zones" "available" {}

resource "aws_vpc" "smava-eks-vpc" {
  cidr_block = "10.0.0.0/16"
  }

resource "aws_subnet" "smava-eks-subnet" {
  count = 2
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "10.0.${count.index}.0/24"
  vpc_id = "${aws_vpc.smava-eks-vpc.id}"
}



