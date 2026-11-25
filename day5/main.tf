provider "aws" {
  region = "us-west-2"
}

variable "cidr" {
  default = "10.0.0.0/16"

}

resource "aws_key_pair" "example" {
  key_name   = "terraform-demo-parsu"
  public_key = file("~/.ssh/id_rsa.pub")
}
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr

}
resource "aws_subnet" "mysubnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

}
resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.myvpc.id

}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }

}
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.RT.id

}

resource "aws_security_group" "websg" {
  name   = "web"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP from vpc"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "web-sg"
  }

}
resource "aws_instance" "server" {
  ami                    = "ami-0087d113babc82cbe"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.websg.id]
  subnet_id              = aws_subnet.mysubnet.id

  connection {
    type        = "ssh"
    user        = "ubuntu"              # Replace with the appropriate username for your EC2 instance
    private_key = file("~/.ssh/id_rsa") # Replace with the path to your private key
    host        = self.public_ip
  }

  # File provisioner to copy a file from local to the remote EC2 instance
  provisioner "file" {
    source      = "app.py"              # Replace with the path to your local file
    destination = "/home/ubuntu/app.py" # Replace with the path on the remote instance
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",
      "sudo apt-get install -y python3-flask",
      "cd /home/ubuntu",
      "sudo nohup python3 /home/ubuntu/app.py > /home/ubuntu/app.log 2>&1 &",
    ]
  }
}

