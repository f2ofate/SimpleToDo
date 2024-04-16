resource "aws_security_group" "postgres" {
  name   = "SG for Postgres"
  vpc_id = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = ["5432", "22", "9116"]
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
    Name = "SG for Postgres"
  }
}

resource "aws_instance" "postgres" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"

  user_data              = file("./pg_data.sh")
  subnet_id              = aws_default_subnet.default.id
  vpc_security_group_ids = [aws_security_group.postgres.id]
  key_name               = "aws"

  root_block_device {
    volume_size = 15
    volume_type = "gp2"

    tags = {
      Name = "Postgres Volume"
    }
  }

  tags = {
    Name = "Postgres Instance"
  }
}

resource "aws_eip_association" "postgres" {
  instance_id   = aws_instance.postgres.id
  allocation_id = "eipalloc-07e20e16262982ad2"
}