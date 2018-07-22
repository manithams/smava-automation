variable "cluster-name" {
  default = "smava-eks-cluster"
  type = "string"
  }

resource "aws_vpc" "smava-vpc" {
  cidr_block = "10.0.0.0/16"
  }

