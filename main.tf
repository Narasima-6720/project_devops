provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "example" {
  ami = var.my_ami
  key_name = var.key_val
  instance_type = var.inst_typeval
  associate_public_ip_address = var.enable_ip_address
  subnet_id = var.sub_idval
  tags = {
    "name" = var.myinsname
  }
  
}


