variable "region" {
  default = "eu-west-2"
}

variable "instance_type" {
  default = "t2.micro"
}
variable "ami"{
  default ="ami-0015a39e4b7c0966f"
}

variable "aws_access_key" {
  type        = string
  sensitive = true
}
variable "aws_secret_key" {
  type        = string
  sensitive = true
}

variable "path_to_script" {
  type        = string
  default = "../../install_logger.sh"
}
