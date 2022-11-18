terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.16"
        }
    }
    required_version = ">= 1.2.0"
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "sumanisawesome"{
    bucket = "marleyandmao1"

    tags = {
        Name        = "marleyandmao1"
        Environment = "Dev"
    }
}

resource "aws_s3_bucket_object" "object" {
    bucket = aws_s3_bucket.sumanisawesome.id
    key = "thisisanobject"
    acl = "public-read"
    source = "../../downloads/cute-koala-sleeping-cartoon-illustration_138676-2778.jpg"
    etag = filemd5("../../downloads/cute-koala-sleeping-cartoon-illustration_138676-2778.jpg")
    content_type = "text/html"
}