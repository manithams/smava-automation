#!/bin/bash -xe

AWS_PROFILE_NAME="smava";

$(which aws) configure set aws_access_key_id "$AWS_ACCESS_KEY" --profile "$AWS_PROFILE_NAME"
$(which aws) configure set aws_secret_access_key "$AWS_SECRET_KEY" --profile "$AWS_PROFILE_NAME"


terraform init
terraform apply -auto-approve -var "access_key=$AWS_ACCESS_KEY" -var "secret_key=$AWS_SECRET_KEY" -var "smava_key_file=$deployer_key_file" -var "smava_pvt_key_file=$deployer_pvt_key_file" -var "profilename=$AWS_PROFILE_NAME";

#terraform output  smava-kubeconfig > smava-kubeconfig
#terraform output config-map-aws-auth > config-map-aws-auth.yaml

mkdir -p ./.kube && cp files/smava-kubeconfig ./.kube/
sed '1,2d' $(pwd)/.kube/smava-kubeconfig > $(pwd)/.kube/smava-kubeconfig-v1
sed '1,2d' $(pwd)/files/config-map-aws-auth.yaml > $(pwd)/files/config-map-aws-auth-v1.yaml
KUBECONFIG=$(pwd)"/.kube/smava-kubeconfig-v1" kubectl apply -f files/config-map-aws-auth-v1.yaml
export KUBECONFIG=/root/smava-automation/.kube/smava-kubeconfig-v1
#kubectl apply -f config-map-aws-auth.yaml
kubectl apply -f files/config-map-aws-auth-v1.yaml
