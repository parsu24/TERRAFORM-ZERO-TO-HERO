provider "aws" {
  region = "us-west-2"

}
resource "aws_instance" "example" {

  ami           = "ami-0087d113babc82cbe"
  instance_type = "t3.micro"

}
