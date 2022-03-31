
resource "aws_instance" "instance1" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = "alpha"
  user_data =file("${var.path_to_script}")
  security_groups = [
        "launch-wizard-4"
    ]
}

resource "aws_s3_bucket" "s3_logs_bucket" {
  bucket = "test-hyasser-s3-terraform"

}

resource "aws_s3_bucket_public_access_block" "s3_logs_bucket_pab" {
  bucket = aws_s3_bucket.s3_logs_bucket.id

  block_public_acls   = true
  block_public_policy = true
}