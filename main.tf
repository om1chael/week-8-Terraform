
# lets run this code with `terraform init`
# You will have to wait

provider "aws"{
region = "eu-west-1"
}


# Task 2
# SRE_key.pem file
# AWS keys setup is allready done 
# public ip 
# instance type configuration
resource "aws_instance" "app_instance" {
  ami = "ami-00e8ddf087865b27f"
  instance_type= "t2.micro"
  associate_public_ip_address = true
  tags = {
     Name = "SRE_Michael_Terraform_app"

  }
}




