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




