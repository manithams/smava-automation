variable "access_key" {}
variable "secret_key" {}


provider "aws" {
  region = "us-east-1"
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
  default = "ami-b7d1dcc8"
}
