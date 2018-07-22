resource "aws_security_group" "smava-eks-master-sg" {
  name = "smava-eks-master-sg"
  description = "Allow communication between master and workers"
  vpc_id = "${aws_vpc.smava-vpc.id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "smava-eks-master-sg"
    }
}


resource "aws_security_group" "smava-eks-minion-sg" {
  name = "smava-eks-minion-sg"
  description = "Security group for all minions in the cluster"
  vpc_id = "${aws_vpc.smava-vpc.id}"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags {
      Name = "smava-eks-minion-sg"
    }
}

resource "aws_security_group_rule" "smava-eks-master-sg-ingress-ws" {
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow local workstations to communicate with the cluster API Server"
  from_port =  443
  protocol = "tcp"
  security_group_id = "${aws_security_group.smava-eks-master-sg.id}"
  to_port = 443
  type = "ingress"
}

resource "aws_security_group_rule" "smava-eks-master-sg-ingress-node-https" {
  description = "Allow local workstations to communicate with the cluster API Server"
  from_port =  443
  protocol = "tcp"
  security_group_id = "${aws_security_group.smava-eks-master-sg.id}"
  source_security_group_id = "${aws_security_group.smava-eks-minion-sg.id}"
  to_port = 443
  type = "ingress"

}


resource "aws_security_group_rule" "smava-eks-minion-sg-ingress-self" {
  description = "Allow node to communicate with each other"
  from_port = 0
  protocol = "-1"
  security_group_id = "${aws_security_group.smava-eks-minion-sg.id}"
  source_security_group_id = "${aws_security_group.smava-eks-minion-sg.id}"
  to_port = 65535
  type = "ingress"
}

resource "aws_security_group_rule" "smava-eks-minion-sg-ingress-cluster" {
  description = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port = 1025
  protocol = "tcp"
  security_group_id = "${aws_security_group.smava-eks-minion-sg.id}"
  source_security_group_id = "${aws_security_group.smava-eks-minion-sg.id}"
  to_port = 65535
  type = "ingress"
}


























