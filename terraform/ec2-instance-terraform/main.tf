
resource "aws_instance" "instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "alpha"
  # user_data =file("${var.path_to_script}")  to be installed through ansible
  security_groups = [
    "launch-wizard-4"
  ]
  tags = {
    Name = "Vois_task_tf${count.index}"
  }
  count = 2

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file("~/.ssh/alpha.pem")
  }
  provisioner "remote-exec" {
    #Make sure instance is ready for executing ansible playbooks later on
    inline = ["echo 'connected!'"]
  }
}

resource "aws_s3_bucket" "s3_logs_bucket" {
  bucket = "test-hyasser-s3-terraform"

}

resource "aws_s3_bucket_public_access_block" "s3_logs_bucket_pab" {
  bucket                  = aws_s3_bucket.s3_logs_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${var.path_to_inv_template}", {
    ip1         = aws_instance.instance[0].public_ip,
    ip2         = aws_instance.instance[1].public_ip,
    ssh_keyfile = "~/.ssh/alpha.pem"
  })
  filename = format("%s/%s", abspath(path.root), "inventory.yaml")
}


resource "null_resource" "run_ansible" {

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook  -i ${var.path_to_inv} init.yml --vault-password-file .vault_pass.txt"
  }

  depends_on = [
    aws_instance.instance[0],
    aws_instance.instance[1],
  ]
}