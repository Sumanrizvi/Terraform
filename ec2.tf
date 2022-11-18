data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    
    owners = ["099720109477"]
}

resource "aws_instance" "web" {
    ami           = data.aws_ami.ubuntu.id
    instance_type = "t3.micro"

    iam_instance_profile = aws_iam_instance_profile.ec2instanceprofile.name

    tags = {
        Name = "HelloWorld"
    }
}

resource "aws_iam_role" "roleforec2" {
    name = "roleforec2"

    assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
POLICY
}

resource "aws_iam_policy" "policyforec2role" {
    name = "policyforec2role"

    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "attachingpoliciesec2" {
    role       = aws_iam_role.roleforec2.name
    policy_arn = aws_iam_policy.policyforec2role.arn
}

resource "aws_iam_instance_profile" "ec2instanceprofile" {
    name = "ec2instanceprofile"
    role = aws_iam_role.roleforec2.name
}