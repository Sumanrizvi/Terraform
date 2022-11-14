resource "aws_s3_bucket" "s3staticwebsitebucket" {
    bucket = "rizvis3staticwebsitelesson1"

    versioning {
        enabled = true
    }
}

resource "aws_s3_bucket_object" "s3staticwebsiteindex" {
    bucket = aws_s3_bucket.s3staticwebsitebucket.id
    key = "index.html"
    source = "./s3-statiswebsite-lesson/index.html"
    acl = "public-read"
    content_type = "text/html"
}

resource "aws_s3_bucket_object" "s3staticwebsiteerror" {
    bucket = aws_s3_bucket.s3staticwebsitebucket.bucket
    key = "error.html"
    source = "./s3-statiswebsite-lesson/error.html"
    acl = "public-read"
    content_type = "text/html"
}

resource "aws_s3_bucket_website_configuration" "s3staticwebsiteconfiguration" {
    bucket = aws_s3_bucket.s3staticwebsitebucket.bucket

    index_document {
        suffix = "index.html"
    }

    error_document {
        key = "error.html"
    }
}