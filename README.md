# Week 8 Terraform:
## What is is ?
## why is it used ?
## Setting up Terraforming 
## Securing AWS Keys for Terraforming 



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
code will dynamically add chnages 


provider "aws"{
region = "eu-west-1

}
Bash command: terraform init 
```
lets run this code with `terraform init`
### You will have to wait


### Create resources on AWS
- lets start launching EC2 inatnces using the app AMI
- `SRE_key.pem` file
- AWS keys setup is allready done 
- public ip 
- instance type configuration

````
resource "aws_instance" "app_instance" {
  ami = "ami-00e8ddf087865b27f"
  instance_type= "t2.micro"
  associate_public_ip_address = true
  tags = {
     Name = "SRE_Michael_Terraform_app"

  }
}
Bash command: terraform plan
```
