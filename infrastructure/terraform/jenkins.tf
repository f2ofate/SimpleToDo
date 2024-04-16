resource "aws_security_group" "jenkins" {
  name   = "SG for Jenkins"
  vpc_id = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = ["80", "8080", "443", "22", "9000", "9090"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG for Jenkins"
  }
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"

  user_data              = file("./data.sh")
  subnet_id              = aws_default_subnet.default.id
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  key_name               = "aws"

  root_block_device {
    volume_size = 25
    volume_type = "gp2"

    tags = {
      Name = "Jenkins Volume"
    }
  }

  tags = {
    Name = "Jenkins Instance"
  }
}

resource "aws_eip_association" "jenkins" {
  instance_id   = aws_instance.jenkins.id
  allocation_id = "eipalloc-0ca58b9f47e484439"
}