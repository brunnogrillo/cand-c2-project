provider "aws" {
    access_key = "AKIATLW4KIRSB7PV5LE2"
    secret_key = "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"
    region = "us-east-1"
}

resource "aws_instance" "Udacity_T2" {
    ami = "ami-0c6b1d09930fac512"
    instance_type = "t2.micro"
    tags = {
        Name = "Udacity T2"
    }
    count = 4
    subnet_id = "subnet-2272d244"
}
