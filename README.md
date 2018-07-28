# Smava-Cyborg

The previous deployment process of the company had lot of manual steps which continuously led to human failures. This is where Smava-Cyborg comes to help.

# Why Smava-Cyborg
* **Repeatability** – Every deployment deploys the same.
* **Fewer errors** – Removing manual steps reduces human error.
* **Anyone can deploy** – eliminate bottlenecks by removing the need for experts to do the work.
* **Work on what matters** – developers can spend time working on new features, not on fixes for manual deployments.
* **Customer satisfaction** – frequent updates with new features addresses customer needs sooner and keeps organizations competitive.
* **Lower costs** – fewer errors, fewer human hours needed for deployments means lower costs.

# What made of Smava-Cyborg
Smava-cyborg comes to play as a [terraform](https://www.terraform.io/intro/index.html) module which will deploy an [EKS](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html) cluster on us-east-1 region, making use of two availability zones for the worker nodes.
Upon successful cluster creation, this will also deploy a [jenkins](https://jenkins.io/doc/) server with three pre-loaded jobs for building a simple hello-world application.

# What Smava-Cyborg does?
#### Creating EKS Cluster 
Creating a VPC for the Amazon EKS cluster with two public subnets and two private subnets, which are provided with internet access through a NAT gateway. EKS cluster will create in the public subnets and Worker nodes will be added to private subnets.
Required IAM roles and Security Groups will be proviosned. 
#### Provision Jenkins server
This module will create a jenkins server for Continues delivery with the pre-built jobs. Jenkins server will be added in the public subnet.

# Prerequisites 
Please make sure following tools are installed/configured before trying this.
* Create an AWS IAM user with neccessary permission for provisioning EKS/EC2 and VPC related services. (Preferably an admin user to avoid any privilege issues)
* Terraform - v0.11.7
* aws-cli - 1.15.40 
* Python - 2.7.15
* heptio-authenticator-aws (EKS leverages IAM user based access via heptio-authenticator)
* kubectl - latest

More information on how to Install:
* Install kubectl and heptio-authenticator-aws is listed [here](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html)
* Install [Terraform](https://www.terraform.io/intro/getting-started/install.html)
* Install [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-linux.html#awscli-install-linux-pip)

# How to setup

 1. First create a SSH Key-pair
 2. Set the following ENV variables with necessary detials.
   ```
    export AWS_ACCESS_KEY=<AWS_ACCESS_KEY>
    export AWS_SECRET_KEY=<AWS_SECRET_KEY>
    export deployer_key_file=<PATH_TO_SSH_PUBLIC_KEY>
    export deployer_pvt_key_file=<PATH_TO_SSH_PVT_KEY>
   ```
 3. Clone this repository
    ```
     git clone https://github.com/manithams/smava-automation.git
    ```
 4. Go to the directory and Run the run.sh script
    ```
     cd smava-automation/
     ./run.sh
    ```
 5. Upon Successful creation check the output for the jenkins server IP address.
    ```
     jenkins-address =<Jenkins-server-IP-address>
     smava-ecr-arn = <arn of created ECR>
     smava-ecr-url = <uri of created ECR>
    ```
 6. Login to the Jenkins server via a browser. (Use default jenkins server port 8080).
 
      *Username and password for the jenkins server can be found in the Output.*
    ```
     http://<Jenkins-server-IP-address>:8080
    ```
 7. Execute the build jobs in following order. Fill the parameters accordingly in each job.
      1. build-jdk-image       
      2. build-job
      3. deploy-job
 
 8. Check the kubernetes cluster for deploymnet creation and make sure the pods are running.
 9. To access the wepapp create the service using following command.
    ```
     kubectl apply --force --validate=false -f ./scripts/smava-helloworld-service.yaml -n smava
    ```
 10. get service details from following cammand.
     ```
     kubectl get svc -n smava
     ```
 11. Get the ELB public DNS to access the service.
 
 # Troubleshooting
 1. After creating the cluster if you cant access the cluster from the workstation using kubectl. Try the following two commands.
    ```
    export KUBECONFIG=/root/smava-automation/.kube/smava-kubeconfig-v1
    kubectl apply -f files/config-map-aws-auth-v1.yaml
    ```
 2. If the running pods showing CrashLoopBackOff status. Remove the images in ECR and run the buildjobs again. 
 
 # Delete the smava-cyborg
 1.If you need to delete/destroy the smava-cyborg. Use terraform destroy as following.
   ```
  terraform destroy -var "access_key=$AWS_ACCESS_KEY" -var "secret_key=$AWS_SECRET_KEY" -var "smava_key_file=$deployer_key_file" -var  "smava_pvt_key_file=$deployer_pvt_key_file"
   ```
 2. Confirm as "yes" when prompts. 
