variable "ssh_keys" {
  type = list(
    object(
      {
        publickey = string
        user      = string
      }
    )
  )
  description = "SSH public keys"
  default = [
      {
        user      = "romarq"
        publickey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDuhU7ZQsftadPUgb40AWJKj+wOX8lTVjYMnl/wQ2heU2AxcHQgzxp3EQ5TyKfrg+wyIYTecRRZkzcA6D6kX0z3LJdKFU3xbdNHKapFAiSMF+Z0wBNtmW8O6+F+WWtgb/Y4Z9yF0brocxyA/ZX9gz6wsMxa2F+a45+mhUvXEbcpxKyxjHKzBvBKwH2LN302iiiyk0FzeEdyCcIz80JLnpGV0/U8VY3OlSm8s79qH4g/KEqey6iVy+G4Irfx8ra3gjYlXr9xEaUkArulXjz4IUbo+LJjrfnE/O51YjFEp9j8DwiDRd1vG0YtVah67pKozJW97zf1H9TTSA1ReTn+B+JTXDEHzk2RFsn7t3/cBZJC5pty8sSHLT/Jk6Lj+ARXSTS/r4ioObjnAMxuRy7n/nRHMMwEDusUl6bY2xYWOEda2GbOn/hO/BLwkbF50OrLzLG6+tYDjw9zf36/CndwhmG6QNTEcp+nmTfEOY7jJhkq5Tp5QtpZ6BfQTak6yNvtWns/MIkV4QPFD/54OPKYGZytdtW0H8FrQSRfCre+4gRbW8DRk4cyx53cCNccBcha3+mGX7E+KcbipIp+x7g6MYfiD26/f4gMRHMsfBJX6a0R3c0AdngERH3MMstwFwZFsHnglr/JCIlB7t4HT1rnxinhXzFnTNZtf7riHaNPm40Viw== rodrigo_quelhas@outlook.pt"
      }
  ]
}

variable "project" {
  type    = string
  default = "visualtez"
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "aws_region_az" {
  type    = string
  default = "eu-west-2a"
}
