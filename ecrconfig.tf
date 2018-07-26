resource "aws_ecr_repository" "smava-ecr" {
  name = "smava-ecr"
}

output "smava-ecr-arn" {
  value = "${aws_ecr_repository.smava-ecr.arn}"
}

output "smava-ecr-url" {
  value = "${aws_ecr_repository.smava-ecr.repository_url}"
}
