provider "aws" {
    access_key = "AKIATLW4KIRSOZAXUCOS"
    secret_key = "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"
    region = "us-east-1"
}

resource "aws_instance" "Udacity_T2" {
    ami = "ami-0c6b1d09930fac512"
    instance_type = "t2.micro"
    count = 4
    subnet_id = "subnet-2272d244"
}
