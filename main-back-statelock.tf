provider "aws" {
  region = "us-east-1"
}
# Instance creation 
resource "aws_instance" "nara_inst" {
  ami                         = "enter your ami id"
  instance_type               = "t2.micro"
  key_name                    = "my-ec2"
  associate_public_ip_address = true
  tags = {
    "Name" = "myinst"
  }
  subnet_id = "enter the subnetid"
}
# s3 bucket creation
resource "aws_s3_bucket" "my_buckt" {
  bucket = "nara-s3-demo-mnr"
 


}


resource "aws_dynamodb_table" "dynamodb-terraform-lock" {
  name         = "terraform-lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    }
    }




    type = "S"
  }
}


