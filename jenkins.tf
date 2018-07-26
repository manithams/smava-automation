resource "aws_instance" "smava-jenkins-server" {
  ami = "${var.jenkins_ami.}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.smava-key.key_name}"
  security_groups = ["${aws_security_group.smava-jenkins-sg.id}"]
  subnet_id = "${aws_subnet.smava-az1-subnets.*.id[0]}"
  associate_public_ip_address = true
  connection {
    user = "ubuntu"
    private_key = "${file(var.smava_pvt_key_file)}"
    agent = false
  }
  lifecycle {
    create_before_destroy = true
  }
  tags {
    Name = "smava-jenkins-server"
  }
  depends_on = [
    "aws_eks_cluster.smava-eks-cluster",
    "null_resource.client-configs"
  ]
  provisioner "file" {
    source = "files/smava-kubeconfig"
    destination = "/tmp/smava-kubeconfig"
  }
  provisioner "remote-exec" {
    inline = [
      "sed -i '1,2d' /tmp/smava-kubeconfig",
      "mkdir -p ~/.kube",
      "mv /tmp/smava-kubeconfig ~/.kube/ ",
      "echo 'export KUBECONFIG=~/.kube/smava-kubeconfig' >> ~/.bashrc",
      "echo ${aws_ecr_repository.smava-ecr.repository_url} > ~/dockerregistry",
    ]
  }
    
}

output "jenkins-address" {
  value = "${aws_instance.smava-jenkins-server.public_ip}"
}

