variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "project_name" {
  type    = string
  default = "minimal-3tier"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  default = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  default = "10.0.2.0/24"
}

variable "private_subnet_a_cidr" {
  default = "10.0.11.0/24"
}

variable "private_subnet_b_cidr" {
  default = "10.0.12.0/24"
}

variable "db_name" {
  default = "productsdb"
}

variable "db_username" {
  default = "admin"
}

variable "frontend_image" {
  default = "nginx:latest"
}

variable "backend_image" {
  default = "nginx:latest"
}

variable "frontend_cpu" {
  default = 256
}

variable "frontend_memory" {
  default = 512
}

variable "backend_cpu" {
  default = 256
}

variable "backend_memory" {
  default = 512
}