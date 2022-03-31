
resource "aws_instance" "instance1" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = "alpha"
  # user_data =file("${var.path_to_script}")
  security_groups = [
        "launch-wizard-4"
    ]
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${var.path_to_inv_template}", {
      ip          = aws_instance.instance1.public_ip,
      ssh_keyfile = "~/.ssh/alpha.pem"
  })
  filename = format("%s/%s", abspath(path.root), "inventory.yaml")
}