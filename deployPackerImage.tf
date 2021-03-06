provider "aws" {  
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-west-2"
}

data "aws_ami" "image" {
  most_recent = true
  owners = ["270957668043"]
  filter {                       
    name = "name"     
    values = ["packer-catalog-example"]
  }        
}



resource "aws_instance" "packer-catalog" {  
  ami           = "${data.aws_ami.image.id}" 
  instance_type = "t2.small"
  security_groups = ["MandeepING-PoC"]
  tags {
      Name = "catalog-green"
    }
  key_name   = "mandeeping-poc"
}
