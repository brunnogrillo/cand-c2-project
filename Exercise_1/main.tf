provider "aws" {
    access_key = "<access_key>"
    secret_key = "<secret_key>"
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

resource "aws_instance" "Udacity_M4" {
    ami = "ami-0c6b1d09930fac512"
    instance_type = "m4.large"
    tags = {
        Name = "Udacity M4"
    }
    count = 2
    subnet_id = "subnet-2272d244"
}