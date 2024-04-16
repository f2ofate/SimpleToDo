resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default" {
  availability_zone = data.aws_availability_zones.working.names[1]

  tags = {
    Name = "Subnet for EC2"
  }
}
