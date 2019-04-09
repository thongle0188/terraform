variable "aws_region" {
  description = "Region Asian Pacific Singapore"
  default     = "ap-southeast-1"
}

variable "aws_access_key" {
  description = "Access Key Thongle"
  default     = "AKIA42L3GJE6R3VO3MFA"
}

variable "aws_secret_key" {
  description = "Secret Key Thongle"
  default     = "w0xuu3RgiYZJ0qy5wbrTk2tA05nmSDT9zMCW/IIk"
}

variable "cidr_vpc" {
  description = "IP vpc"
  default     = "10.0.0.0/16"
}

variable "web_subnet" {
  description = "IP web subnet"
  default     = "10.0.1.0/24"
}

variable "db_subnet" {
  description = "IP db subnet"
  default     = "10.0.2.0/24"
}

variable "key_path" {
  description = "SSH key"
  default     = "/home/thong/.ssh/aws_key.pub"
}

variable "ami" {
  description = "AWS ubuntu server 18.04 LTS"
  default = "ami-0dad20bd1b9c8c004"
}
