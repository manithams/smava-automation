resource "aws_eks_cluster" "smava-eks-cluster" {
  name = "${var.cluster-name}"
  role_arn = "${aws_iam_role.smava-eks-master-iam-role.arn}"
  vpc_config {
    security_group_ids =  ["${aws_security_group.smava-eks-master-sg.id}"]
    subnet_ids = ["${aws_subnet.smava-az1-subnets.*.id[0]}","${aws_subnet.smava-az2-subnets.*.id[0]}"]
  }
  depends_on = [
    "aws_iam_role_policy_attachment.smava-eks-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.smava-eks-AmazonEKSServicePolicy",
    "aws_internet_gateway.smava-igw",
  ]
}
