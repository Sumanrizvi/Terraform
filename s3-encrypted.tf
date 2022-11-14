resource "aws_s3_bucket" "encryptingbuckets" {
    bucket = "sumansencryptedbucket"

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}
    

