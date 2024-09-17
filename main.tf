
#Deploy AWS Target
provider "aws" {
    access_key = var.access_key
    secret_key = var.secret_key
    region = var.region
}

resource "aws_instance" "ssh-target" {
  ami                  = "ami-05134c8ef96964280"
  instance_type        = "t2.micro"
  key_name             = "boundary-vault-keypair"
  vpc_security_group_ids = ["sg-0d3f1e99f596b7655"]
  subnet_id              = "subnet-0aea8366156988c03" 
  tags = {
    Name = var.vm_name
  }
}

#Configure and add target to Boundary
provider "boundary" {
  addr                            = var.url
  auth_method_login_name = var.username          # changeme
  auth_method_password   = var.password       # changeme
}

#Boundary Config
resource "boundary_target" "target" {
  name                 = var.vm_name
  description          = "Target created by Terraform"
  type                 = "ssh"
  default_port         = "22"
  scope_id             = var.scope_id
  address              = aws_instance.ssh-target.public_ip
  injected_application_credential_source_ids = [
    var.cred_id
  ]
}

