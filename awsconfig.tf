variable "access_key" {}
variable "secret_key" {}

variable "region" {
  default = "us-east-1"
  }

provider "aws" {
  region = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

variable "account_owner" {
  default = "520447751155"
}

variable "profilename" {
  default = "smava"
}

variable "smava_key_file" {}
variable "smava_pvt_key_file" {}

variable "jenkins_ami" {
  default = "ami-3bc6ce44"
}
