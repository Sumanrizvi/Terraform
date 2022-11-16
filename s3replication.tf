provider "aws" {
    alias = "central"
    region = "eu-central-1"
}

resource "aws_s3_bucket" "sourcereplicationbuckets"{
    bucket = "sumanreplicatingsourcebucket"

    versioning {
        enabled = true
    }
}

resource "aws_s3_bucket" "destinationreplicationbuckets"{
    bucket = "sumanreplicatingdestinationbucket"
    provider = aws.central

    versioning {
        enabled = true
    }
}

resource "aws_iam_role" "replication" {
    name = "replicationrole"

    assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "s3.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}  
POLICY
}

resource "aws_iam_policy" "replication" {
    name = "replicationpolicy"

    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:GetReplicationConfiguration",
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "${aws_s3_bucket.sourcereplicationbuckets.arn}"
            ]
        },
        {
            "Action": [
                "s3:GetObjectVersionForReplication",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectVersionTagging"
            ],
            "Effect": "Allow",
            "Resource": [
                "${aws_s3_bucket.sourcereplicationbuckets.arn}/*"
            ]
        },
        {
            "Action": [
                "s3:ReplicateObject",
                "s3:ReplicateDelete",
                "s3:ReplicateTags"
            ],
            "Effect": "Allow",
            "Resource": "${aws_s3_bucket.destinationreplicationbuckets.arn}/*"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "attachingpolicies" {
    role       = aws_iam_role.replication.name
    policy_arn = aws_iam_policy.replication.arn
}

resource "aws_s3_bucket_replication_configuration" "replicationconfiguration" {
    role = aws_iam_role.replication.arn
    bucket = aws_s3_bucket.sourcereplicationbuckets.id

    rule {
        id = "replicatigtocentral"

        status = "Enabled"

        destination {
            bucket = aws_s3_bucket.destinationreplicationbuckets.arn
        }
    }
}