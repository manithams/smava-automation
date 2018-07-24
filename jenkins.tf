resource "aws_instance" "smava-jenkins-server" {
  ami = "${var.jenkins_ami.}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.smava-key.key_name}"
  security_groups = ["${aws_security_group.smava-jenkins-sg.id}"]
  subnet_id = "${aws_subnet.smava-az1-subnets.*.id[0]}"
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
  tags {
    Name = "smava-jenkins-server"
  }
  depends_on = [
    "aws_eks_cluster.smava-eks-cluster",
  ]
    
}
