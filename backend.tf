#backend code for state lock and remote backend
terraform {
  backend "s3" {
    bucket = "nara-s3-demo-mnr"
    region = "us-east-1"
    key = "nara/terraform.tfstate"
    dynamodb_table = "terraform-lock"
  }
}
