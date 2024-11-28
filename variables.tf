
variable "vm_name" {
}

variable "aws_run_role_arn" {
  description = "AWS Role ARN to assume for Terraform runs"
  type        = string
}


variable "url" {
    default = ""
}

variable "username" {
    default = ""
}

variable "password" {
    default = ""
}
variable "region" {
    default = "eu-west-2"
  
}

variable "scope_id" {
    default = ""
}
variable "cred_id" {
  default = ""
}
