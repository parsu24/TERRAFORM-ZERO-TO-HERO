provider "aws" {
  region = "us-west-2"
}

variable "ami" {
  description = "value for ami"

}
variable "instance_type" {
  description = "value for instance type"

}

resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = var.instance_type
}
