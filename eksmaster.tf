resource "aws_eks_cluster" "smava-eks-cluster" {
  name = "${var.cluster-name}"
  role_arn = "${aws_iam_role.smava-eks-iam-role.arn}"
  vpc_config {
    security_group_ids =  ["${aws_security_group.smava-eks-sg.id}"]
    subnet_ids = ["${aws_subnet.smava-az1-subnets.*.id[0]}","${aws_subnet.smava-az2-subnets.*.id[0]}"]
  }
}
