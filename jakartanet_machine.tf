output "jakartanet_external_ip" {
    value       = aws_instance.jakartanet.public_ip
    description = "The public IP address of jakartanet instance."
}

resource "aws_security_group" "tezos_traffic" {
    name        = "tezos_traffic"
    description = "Allow Tezos related traffic"
    vpc_id      = "vpc-0c95b03efc0ec1358"

    ingress {
        description     = "Allow SSH inbound traffic"
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    ingress {
        description     = "Allow HTTP inbound traffic"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    ingress {
        description     = "Allow TLS inbound traffic"
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    ingress {
        description     = "Allow P2P inbound traffic"
        from_port       = 9732
        to_port         = 9732
        protocol        = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    lifecycle {
        create_before_destroy = true
    }

    tags = {
        Name = "tezos_traffic"
    }
}

resource "aws_instance" "jakartanet" {
    # https://cloud-images.ubuntu.com/locator/ec2
    ami                         = "ami-01361e35a99201b48"

    instance_type               = "t4g.large"
    associate_public_ip_address = true
    vpc_security_group_ids      = [
        aws_security_group.tezos_traffic.id
    ]

    key_name                    = aws_key_pair.ssh.id

    tags = {
        Name = "jakartanet-vm"
    }
}

resource "aws_ebs_volume" "jakartanet" {
    availability_zone = aws_instance.jakartanet.availability_zone
    type              = "gp2"
    size              = 100

    tags = {
        Name = "jakartanet-volume"
    }
}

resource "aws_volume_attachment" "jakartanet" {
    device_name = "/dev/sdf"
    volume_id   = aws_ebs_volume.jakartanet.id
    instance_id = aws_instance.jakartanet.id
}
