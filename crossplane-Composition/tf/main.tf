resource "aws_s3_bucket" "paas-cp" {
bucket = var.Bucket
force_destroy = var.Forcedestroy
tags = {
    Name        = var.Bucket
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
    status = var.VersioningConfiguration
  }
}
terraform {
  backend "s3" {
    bucket = "tfstate-bucket"
    key    = "cp-tf-remote-s3"
    region = "us-west-2"
    shared_credentials_file = "aws-creds.ini"
    workspace_key_prefix = "crossplane-test-remote-cp-s3"
  }
}


variable "LocationConstraint" {}
variable "acl" {}
variable "VersioningConfiguration" {}
variable "Bucket" {}
variable "Forcedestroy" {}
variable "env" {}
