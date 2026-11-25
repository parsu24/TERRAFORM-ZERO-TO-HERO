module "ec2_instance" {
  source        = "./modules/ec2_instance"
  ami_id        = "ami-0087d113babc82cbe"
  instance_type = "t3.micro"
}
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "my-s3-bucket"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}
