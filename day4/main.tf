provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "parsu_instance" {
  ami           = "ami-0087d113babc82cbe"
  instance_type = "t3.micro"

}
resource "aws_s3_bucket" "parsu_bucket" {
  bucket = "parsu24-devops-terraform"
}
