resource "aws_iam_role" "smava-eks-master-iam-role" {
  name = "smava-eks-master-iam-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
        "Action": "sts:AssumeRole"
     }
   ]
}
  POLICY
}
resource "aws_iam_role_policy_attachment" "smava-eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = "${aws_iam_role.smava-eks-master-iam-role.name}"
}

resource "aws_iam_role_policy_attachment" "smava-eks-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role = "${aws_iam_role.smava-eks-master-iam-role.name}"
}


resource "aws_iam_role" "smava-eks-minion-iam-role" {
  name = "smava-eks-minion-iam-role"
    assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect":"Allow",
        "Principal": {
         "Service": "eks.amazonaws.com"
         },
           "Action": "sts:AssumeRole"
      }
    ]
}
    POLICY
}


resource "aws_iam_role_policy_attachment" "smava-eks-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = "${aws_iam_role.smava-eks-minion-iam-role.name}"
}


resource "aws_iam_role_policy_attachment" "smava-eks-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = "${aws_iam_role.smava-eks-minion-iam-role.name}"
}

resource "aws_iam_role_policy_attachment" "smava-eks-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = "${aws_iam_role.smava-eks-minion-iam-role.name}"
}

resource "aws_iam_instance_profile" "smava-eks-minion-profile" {
  name = "smava-eks-minion-profile"
  role = "${aws_iam_role.smava-eks-minion-iam-role.name}"
}







