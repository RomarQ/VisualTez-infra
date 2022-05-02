output "mainnet_external_ip" {
    value       = aws_instance.mainnet.public_ip
    description = "The public IP address of mainnet instance."
}

resource "aws_instance" "mainnet" {
    # https://cloud-images.ubuntu.com/locator/ec2
    ami                         = "ami-01361e35a99201b48"

    instance_type               = "t4g.large"
    associate_public_ip_address = true
    vpc_security_group_ids      = [
        aws_security_group.tezos_traffic.id
    ]

    key_name                    = aws_key_pair.ssh.id

    tags = {
        Name = "mainnet-vm"
    }
}

resource "aws_ebs_volume" "mainnet" {
    availability_zone = aws_instance.mainnet.availability_zone
    type              = "gp2"
    size              = 60

    tags = {
        Name = "mainnet-volume"
    }
}

resource "aws_volume_attachment" "mainnet" {
    device_name = "/dev/sdf"
    volume_id   = aws_ebs_volume.mainnet.id
    instance_id = aws_instance.mainnet.id
}
