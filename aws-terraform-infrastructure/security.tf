
resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Security group for Terraform EC2 web server"
  vpc_id      = aws_vpc.main.id

  # SSH access only from your IP
  ingress {
    description = "SSH from authorized IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  # HTTP access from internet
  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-web-sg"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
