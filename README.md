# Smava-Cyborg

In the past the deployment process of the company consisted of a lot of manual steps which continuously led to human failures. As a solution we can automate the deployment process.This is where Smava-Cyborg comes to shine.

# Why Smava-Cyborg
* **Repeatability** – Every deployment deploys the same.
* **Fewer errors** – Removing manual steps reduces human error.
* **Anyone can deploy** – eliminate bottlenecks by removing the need for experts to do the work.
* **Work on what matters** – developers can spend time working on new features, not on fixes for manual deployments.
* **Customer satisfaction** – frequent updates with new features addresses customer needs sooner and keeps organizations competitive.
* **Lower costs** – fewer errors, fewer human hours needed for deployments means lower costs.

# What made of Smava-Cyborg
Smava-cyborg comes to play as a [terraform](https://www.terraform.io/intro/index.html) module which will deploy an [EKS](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html) cluster on us-east-1 region, making use of two availability zones for the worker nodes.
Upon successful cluster creation, this will also deploy a [jenkins](https://jenkins.io/doc/) server with two preloaded jobs for building a simple hello-world application.

# Architecture.
## VPC for EKS 
creating a VPC for the Amazon EKS cluster with two public subnets and two private subnets, which are provided with internet access through a NAT gateway.

