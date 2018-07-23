locals {
  config-map-aws-auth = <<CONFIGMAPAWSAUTH


apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.smava-eks-minion-iam-role.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH
}

output "config-map-aws-auth" {
  value = "${local.config-map-aws-auth}"
}

locals {
  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.smava-eks-cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.smava-eks-cluster.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: heptio-authenticator-aws
      args:
        - "token"
        - "-i"
        - "${var.cluster-name}"
      env:
        - name: AWS_PROFILE
          value: "${var.profilename}"
KUBECONFIG
}

output "smava-kubeconfig" {
  value = "${local.kubeconfig}"
}

resource "null_resource" "client-configs" {
  provisioner "local-exec" {
    command = "mkdir -p ./files && terraform output smava-kubeconfig > files/smava-kubeconfig"
  }
  provisioner "local-exec" {
    command = "mkdir -p ./files && terraform output config-map-aws-auth > files/config-map-aws-auth.yaml"
  }
  depends_on = [
    "aws_eks_cluster.smava-eks-cluster",
    "aws_autoscaling_group.smava-eks-minion-asg",
    ]
}












