
resource "aws_instance" "instance1" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = "alpha"
  # user_data =file("${var.path_to_script}")  to be installed through ansible
  security_groups = [
        "launch-wizard-4"
    ]
  tags = {
    Name = "Vois_task_ansible1"
  }
}

resource "aws_instance" "instance2" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = "alpha"
  # user_data =file("${var.path_to_script}")  to be installed through ansible
  security_groups = [
        "launch-wizard-4"
    ]
  tags = {
    Name = "Vois_task_ansible2"
  }
}

resource "aws_s3_bucket" "s3_logs_bucket" {
  bucket = "test-hyasser-s3-terraform"

}

resource "aws_s3_bucket_public_access_block" "s3_logs_bucket_pab" {
  bucket = aws_s3_bucket.s3_logs_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${var.path_to_inv_template}", {
      ip1          = aws_instance.instance1.public_ip,
      ip2          = aws_instance.instance2.public_ip,
      ssh_keyfile = "~/.ssh/alpha.pem"
  })
  filename = format("%s/%s", abspath(path.root), "inventory.yaml")
}