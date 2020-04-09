##
## Provider definition
##
provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "jenkins" {
  ami = "ami-0d1cd67c26f5fca19"
  instance_type = "t2.micro"
  subnet_id = var.aws_subnet_id
  vpc_security_group_ids = [aws_security_group.jenkins_security_group.id]
  associate_public_ip_address = true

  tags = {
    Name = "Sparkling Water Jenkins"
  }

  provisioner "file" {
    source      = "init.sh"
    destination = "/tmp/init.sh"
  }

  provisioner "remote-exec" {
    script = "/tmp/init.sh"
  }
}

resource "aws_security_group" "jenkins_security_group" {
  description = "Security group for master node"
  vpc_id = var.aws_vpc_id
  revoke_rules_on_delete = true

  // SSH Access to Jenkins Machine
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]

    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  // Web Access to Jenkins Machine
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]

    from_port = 0
    to_port = 8080
    protocol = "http"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}
