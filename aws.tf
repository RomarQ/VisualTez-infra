resource "aws_key_pair" "ssh" {
    key_name   = var.ssh_keys[0].user
    public_key = var.ssh_keys[0].publickey
}
