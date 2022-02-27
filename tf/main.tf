resource "aws_s3_bucket" "paas-cp" {
bucket = var.bucket
tags = {
    Name        = var.bucket
    Environment = var.env
    }
}
resource "aws_s3_bucket_acl" "acl-test" {
    bucket = aws_s3_bucket.paas-cp.id
    acl    = var.acl
}


resource "aws_s3_bucket_versioning" "versioning_test" {
  bucket = aws_s3_bucket.paas-cp.id
  versioning_configuration {
    status = var.versioning
  }
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


