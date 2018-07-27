data "template_file" "configure-awscli" {
  template = "${file("./scripts/configure-awscli.tpl")}"
  vars {
    accesskey   = "${var.access_key}"
    secretkey   = "${var.secret_key}"
    profilename = "${var.profilename}"
    region      = "${var.region}"
  }
}

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
  provisioner "file" {
    source = "files/config-map-aws-auth-v1.yaml"
    destination = "/tmp/config-map-aws-auth-v1.yaml"
  }

  provisioner "file" {
    content = "${data.template_file.configure-awscli.rendered}"
    destination = "/tmp/configure-awscli.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ~/.kube",
      "cp /tmp/smava-kubeconfig ~/.kube/ ",
      "echo 'export KUBECONFIG=~/.kube/smava-kubeconfig' >> ~/.bashrc",
      "echo ${aws_ecr_repository.smava-ecr.repository_url} > ~/dockerregistry",
      "sed -i '2,3d' /tmp/configure-awscli.sh",
      "chmod +x /tmp/configure-awscli.sh",
      "cp /home/ubuntu/.aws/credentials /tmp/credentials",
      "chmod +rx /tmp/credentials",
      "sed -i '1,2d' /tmp/smava-kubeconfig"
    ]
  }
    
}

output "jenkins-address" {
  value = "${aws_instance.smava-jenkins-server.public_ip}"
}

