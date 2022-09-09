terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_instance" "sofian-test-server" {
  ami = "ami-0b55fc9b052b03618"
  instance_type = "t2.micro"
}

provider "aws" {
  profile = "sofian-outlook"
  region = "ap-southeast-2"
}