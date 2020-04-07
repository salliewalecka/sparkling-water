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
