variable "region" {
  default = "us-east-1"
}

variable "local_cidr" {
  type = string
  default = "10.0.0.0/24"
}

variable "global_cidr" {
  type = string
  default = "0.0.0.0/0"
}

variable "public_subnet_cidr" {
  type = list(string)
  default = [
    "10.0.0.0/28", 
    "10.0.0.16/28"
  ]
}

variable "private_backend_subnet_cidr" {
  type = list(string)
  default = [
    "10.0.0.32/28", 
    "10.0.0.48/28"
  ]
}

variable "private_db_subnet_cidr" {
  type = list(string)
  default = [
    "10.0.0.64/28", 
    "10.0.0.80/28"
  ]
}

variable "availability_zones" {
  type = list(string)
  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}

variable "tags" {
  type = map(string)
  default = {
    "coherent:owner" = "ArtemLavruschik@coherentsolutions.com"
    "coherent:project" = "Training"
    "coherent:client" = "Coherent"
    "coherent:environment" = "dev"
  }
}

variable "pem_key" {
  type = string
  default = "alavruschik_trainee"
}

variable "subscription_email" {
  type = string
  default = "artemlavruschik@coherentsolutions.com"
}