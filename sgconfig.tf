resource "aws_security_group" "smava-eks-sg" {
  name = "smava-eks-sg"
  description = "Allow communication between master and workers"
  vpc_id = "${aws_vpc.smava-vpc.id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "smava-eks-sg"
    }
}

resource "aws_security_group_rule" "smava-eks-sg-inboound-1" {
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow local workstations to communicate with the cluster API Server"
  from_port =  443
  protocol = "tcp"
  security_group_id = "${aws_security_group.smava-eks-sg.id}"
  to_port = 443
  type = "ingress"

}
