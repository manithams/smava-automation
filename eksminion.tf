data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
        values = ["eks-worker-*"]
   }

   most_recent = true
   owners      = ["602401143452"]
}

data "aws_region" "current" {}

locals {
  smava-eks-minion-userdata = <<USERDATA
#!/bin/bash -xe
CA_CERTIFICATE_DIRECTORY=/etc/kubernetes/pki
CA_CERTIFICATE_FILE_PATH=$CA_CERTIFICATE_DIRECTORY/ca.crt
mkdir -p $CA_CERTIFICATE_DIRECTORY
echo "${aws_eks_cluster.smava-eks-cluster.certificate_authority.0.data}" | base64 -d >  $CA_CERTIFICATE_FILE_PATH
INTERNAL_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
sed -i s,MASTER_ENDPOINT,${aws_eks_cluster.smava-eks-cluster.endpoint},g /var/lib/kubelet/kubeconfig
sed -i s,CLUSTER_NAME,${var.cluster-name},g /var/lib/kubelet/kubeconfig
sed -i s,REGION,${data.aws_region.current.name},g /etc/systemd/system/kubelet.service
sed -i s,MAX_PODS,20,g /etc/systemd/system/kubelet.service
sed -i s,MASTER_ENDPOINT,${aws_eks_cluster.smava-eks-cluster.endpoint},g /etc/systemd/system/kubelet.service
sed -i s,INTERNAL_IP,$INTERNAL_IP,g /etc/systemd/system/kubelet.service
DNS_CLUSTER_IP=10.100.0.10
if [[ $INTERNAL_IP == 10.* ]] ; then DNS_CLUSTER_IP=172.20.0.10; fi
sed -i s,DNS_CLUSTER_IP,$DNS_CLUSTER_IP,g /etc/systemd/system/kubelet.service
sed -i s,CERTIFICATE_AUTHORITY_FILE,$CA_CERTIFICATE_FILE_PATH,g /var/lib/kubelet/kubeconfig
sed -i s,CLIENT_CA_FILE,$CA_CERTIFICATE_FILE_PATH,g  /etc/systemd/system/kubelet.service
systemctl daemon-reload
systemctl restart kubelet
USERDATA
}

resource "aws_launch_configuration" "smava-eks-minion-lc" {
  associate_public_ip_address = true
  iam_instance_profile = "${aws_iam_instance_profile.smava-eks-minion-profile.name}"
  image_id = "${data.aws_ami.eks-worker.id}"
  instance_type = "t2.micro"
  name_prefix = "smava-eks-minion-lc"
  security_groups = ["${aws_security_group.smava-eks-minion-sg.id}"]
  user_data_base64 = "${base64encode(local.smava-eks-minion-userdata)}"

lifecycle {
  create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "smava-eks-minion-asg" {
  desired_capacity = 2
  launch_configuration = "${aws_launch_configuration.smava-eks-minion-lc.id}"
  max_size = 2
  min_size = 1
  name = "smava-eks-minion-asg"
  vpc_zone_identifier = ["${aws_subnet.smava-az1-subnets.*.id[0]}", "${aws_subnet.smava-az2-subnets.*.id[0]}"]
  tag {
    key = "Name"
    value = "smava-eks-minion"
    propagate_at_launch = true
    }
}










































