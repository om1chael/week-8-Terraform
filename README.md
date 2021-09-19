# Week 8 Terraform:
Questions: 
- What is is ?
- why is it used ?
- Setting up Terraforming 
- Securing AWS Keys for Terraforming 

![image](https://user-images.githubusercontent.com/17476059/133597186-f0432314-9f30-450b-8684-4f9c24b814b1.png)

Main commands:

```
Main commands:
  init          Prepare your working directory for other commands
  validate      Check whether the configuration is valid
  plan          Show changes required by the current configuration
  apply         Create or update infrastructure
  destroy       Destroy previously-created infrastructure

All other commands:
  console       Try Terraform expressions at an interactive command prompt
  fmt           Reformat your configuration in the standard style
  force-unlock  Release a stuck lock on the current workspace
  get           Install or upgrade remote Terraform modules
  graph         Generate a Graphviz graph of the steps in an operation
  import        Associate existing infrastructure with a Terraform resource
  login         Obtain and save credentials for a remote host
  logout        Remove locally-stored credentials for a remote host
  output        Show output values from your root module
  providers     Show the providers required for this configuration
  refresh       Update the state to match remote systems
  show          Show the current state or a saved plan
  state         Advanced state management
  taint         Mark a resource instance as not fully functional
  test          Experimental support for module integration testing
  untaint       Remove the 'tainted' state from a resource instance
  version       Show the current Terraform version
  workspace     Workspace management

```

Terraform:
code will dynamically add chanages, but first create the instace first  using `terraform init`, Then wait.
```
provider "aws"{
region = "eu-west-1
}
```

### Create resources on AWS
- lets start launching EC2 inatnces using the app AMI
- `SRE_key.pem` file
- AWS keys setup is allready done 
- public ip 
- instance type configuration

```
resource "aws_instance" "app_instance" {
  ami = "ami-00e8ddf087865b27f"
  instance_type= "t2.micro"
  associate_public_ip_address = true
  tags = {
     Name = "SRE_Michael_Terraform_app"
  }
}
```
Bash command: `terraform plan` this will check the syntax of the script  


## Steps
- step 1 create vpc with CDIR block
- run terraform plan then terraform apply 
- get the vpc id from aws or terraform logs


## creating the internet gateway
```
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "SRE_michael_igw2"
  }
}
```
## aws subnet 
```
resource "aws_subnet" "public_subnet" {
vpc_id = "${aws_vpc.main.id}"
cidr_block       = "10.107.1.0/24"
map_public_ip_on_launch = true
tags = {
		Name = "sre_michael_terraform_app"
	}
}
```
## aws route table
```
resource "aws_route" "sre_route_ig_connection" {
    route_table_id = var.route_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_aws
}

```


### SECURITY GROUP
```
resource "aws_security_group" "ssh-allowed" {
    vpc_id = aws_vpc.main.id
    name = "sre_michael_app_sg_terraform"
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
     ingress {
        from_port       = "22"
        to_port         = "22"
        protocol        = "tcp"
        cidr_blocks     = ["86.172.51.14/32"]  
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port       = "3000"
        to_port         = "3000"
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]  
    }
    tags= {
        Name = "ssh-allowed"
    }
}
```


## configure the aws instance 
### the subnet will be added into the instance by  using vpc_security_group_ids  
```
resource "aws_instance" "app_instance" {
  ami = "ami-00e8ddf087865b27f"
  instance_type= "t2.micro"
  associate_public_ip_address = true

  subnet_id = var.subnet_id
  key_name = var.aws_key_name
  vpc_security_group_ids = [var.sec_group]
  # the Public SSH key
connection {
		type = "ssh"
		user = "ubuntu"
		private_key = var.aws_key_path
		host = "${self.associate_public_ip_address}"
	} 
  tags = {
     Name = "SRE_Michael_Terraform_app"
  }
}
```
type `terraform build` to create the instance



# step 1 create vpc with CDIR block
# run terraform plan then terraform apply 
# get the vpc id from aws or terraform logs


## creating the internet gateway
```
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "SRE_michael_igw2"
  }
}
```
## aws subnet 
```
resource "aws_subnet" "public_subnet" {
vpc_id = "${aws_vpc.main.id}"
cidr_block       = "10.107.1.0/24"
map_public_ip_on_launch = true
tags = {
		Name = "sre_michael_terraform_app"
	}
}
```
## aws route table
```
resource "aws_route" "sre_route_ig_connection" {
    route_table_id = var.route_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_aws
}

```


### SECURITY GROUP
```
resource "aws_security_group" "ssh-allowed" {
    vpc_id = aws_vpc.main.id
    name = "sre_michael_app_sg_terraform"
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
     ingress {
        from_port       = "22"
        to_port         = "22"
        protocol        = "tcp"
        cidr_blocks     = ["86.172.51.14/32"]  
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port       = "3000"
        to_port         = "3000"
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]  
    }
    tags= {
        Name = "ssh-allowed"
    }
}
```


## configure the aws instance 
### the subnet will be added into the instance by  using vpc_security_group_ids  
```
resource "aws_instance" "app_instance" {
  ami = "ami-00e8ddf087865b27f"
  instance_type= "t2.micro"
  associate_public_ip_address = true

  subnet_id = var.subnet_id
  key_name = var.aws_key_name
  vpc_security_group_ids = [var.sec_group]
  # the Public SSH key
connection {
		type = "ssh"
		user = "ubuntu"
		private_key = var.aws_key_path
		host = "${self.associate_public_ip_address}"
	} 
  tags = {
     Name = "SRE_Michael_Terraform_app"
  }
}
```
type `terraform build` to create the instance



## Creating the BD instance:
### Tasks:
- Create DB private Subnet
- Configure Security Groups for DB
- Configure BD network
    - Connect DB AMI
    - connect AMI
    


___
### Create DB Subnet and connect to VPN
```
# SUBNET private
resource "aws_subnet" "private" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.107.2.0/24"
  map_public_ip_on_launch = true
  #availability_zone = "eu-west-1a"
  tags = {
    Name = "sre_michael_terraform_DB_private_subnet"
    }
}

```


## Configure Security Groups for DB
```
resource "aws_security_group" "DB_sg" {
    vpc_id = aws_vpc.main.id
    name = "sre_michael_DB_sg_terraform"
```
## Rules

egress = outbound    
```
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
```
ingress = inbound 
```
     ingress {
        from_port       = "22"
        to_port         = "22"
        protocol        = "tcp"
        cidr_blocks     = ["Your IP/32"]
    }
        ingress {
    from_port       = "27017"
    to_port         = "27017"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
      tags= {
        Name = "SRE_Michael_DB-SG-Terraform"
    }

}
```

## Configure DB network
```
resource "aws_instance" "DB_instance" {
  ami = "** ami - ID **"
  instance_type= "t2.micro"
  associate_public_ip_address = true

  subnet_id = var.subnet_id
  key_name = var.aws_key_name
  vpc_security_group_ids = [var.sec_DB-group]

tags = {
   Name = "sre_michael_terraform_db"
  }
  

connection {
		type = "ssh"
		user = "ubuntu"
		private_key = var.aws_key_path
		host = aws_instance.app_instance.public_ip
}
} 

```
# Configure Load Balancing and Auto Scaling
