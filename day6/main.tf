provider "aws" {
  region = "us-west-2"
}

variable "ami" {
  description = "value"
}
variable "instance_type" {
  description = "value"
  type        = map(string)

  default = {
    "dev"   = "t3.micro"
    "stage" = "t3.small"
    "prod"  = "t8i.micro"
  }

}
module "ec2_instance" {
  source        = "./modules/ec2_instance"
  ami           = var.ami
  instance_type = lookup(var.instance_type, terraform.workspace, "t3.micro")
}
