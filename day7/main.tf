provider "aws" {
  region = "us-west-2"

}
provider "vault" {
  address          = "http://184.36.174.251:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = ""
      secret_id = ""

    }
  }

}
data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "test-secret"
}
resource "aws_instance" "example" {
  ami           = "ami-0087d113babc82cbe"
  instance_type = "t3.micro"

  tags = {
    secret = data.vault_kv_secret_v2.example.data["username"]
  }

}
