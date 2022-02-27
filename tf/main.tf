resource "aws_s3_bucket" "paas-cp" {
bucket = "paas-cp-s3-remote"
tags = {
    Name        = "arun"
    Environment = "Dev"
    }
}
resource "aws_s3_bucket_acl" "acl-test" {
    bucket = aws_s3_bucket.paas-cp.id
    acl    = "private"
}

provider "aws" {
  region = "us-west-2"
  
}

terraform {
  backend "s3" {
    bucket = "paas-us-west-2-development-tfstate-bucket"
    key    = "test-1-remote-s3"
    region = "us-west-2"
    shared_credentials_file = "aws-creds.ini"
    workspace_key_prefix = "crossplane-test-remote-s3"
  }
}


