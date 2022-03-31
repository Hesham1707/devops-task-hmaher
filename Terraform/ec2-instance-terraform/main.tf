
resource "aws_instance" "instance1" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = "alpha"
  user_data =var.path_to_script
}

