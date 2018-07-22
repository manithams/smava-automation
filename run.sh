#!/bin/bash -xe

AWS_PROFILE_NAME="smava";

$(which aws) configure set aws_access_key_id "$AWS_ACCESS_KEY" --profile "$AWS_PROFILE_NAME"
$(which aws) configure set aws_secret_access_key "$AWS_SECRET_KEY" --profile "$AWS_PROFILE_NAME"


terraform init
terraform apply -auto-approve -var "access_key=$AWS_ACCESS_KEY" -var "secret_key=$AWS_SECRET_KEY"

terraform output  smava-kubeconfig > smava-kubeconfig
terraform output config-map-aws-auth > config-map-aws-auth.yaml

mkdir -p ./.kube && mv smava-kubeconfig ./.kube/
KUBECONFIG=$(pwd)"/.kube/smava-kubeconfig" kubectl apply -f config-map-aws-auth.yaml

kubectl apply -f config-map-aws-auth.yaml

