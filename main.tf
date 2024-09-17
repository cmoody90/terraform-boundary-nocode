terraform {
  required_providers {
    boundary = {
      source  = "hashicorp/boundary"
      version = ">= 0.4.0"
    }
  }
}

# AWS Provider
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

# EC2 Instance
resource "aws_instance" "ssh-target" {
  ami                    = "ami-05134c8ef96964280"
  instance_type          = "t2.micro"
  key_name               = "boundary-vault-keypair"
  vpc_security_group_ids = ["sg-0d3f1e99f596b7655"]
  subnet_id              = "subnet-0aea8366156988c03"
  tags = {
    Name = var.vm_name
  }
}

# Boundary Provider
provider "boundary" {
  addr                   = var.url
  auth_method_login_name = var.username
  auth_method_password   = var.password
}

# Define a Static Host
resource "boundary_host_static" "ssh_host" {
  type            = "static"
  name            = "ssh-host"
  description     = "SSH Host for EC2 instance"
  address         = aws_instance.ssh-target.public_ip
  host_catalog_id = "hcst_94IxZYoE6B"
}

# Create a Static Host Set
resource "boundary_host_set_static" "ssh_host_set" {
  type            = "static"
  name            = "ssh-host-set"
  description     = "Host Set for SSH Hosts"
  host_catalog_id = "hcst_94IxZYoE6B"

  host_ids = [
    boundary_host_static.ssh_host.id
  ]
}

# Configure and Add Target to Boundary
resource "boundary_target" "target" {
  name                                      = var.vm_name
  description                               = "Target created by Terraform"
  type                                      = "ssh"
  default_port                              = "22"
  scope_id                                  = var.scope_id
  host_set_ids                              = [boundary_host_set_static.ssh_host_set.id]
  injected_application_credential_source_ids = [
    var.cred_id
  ]
}
