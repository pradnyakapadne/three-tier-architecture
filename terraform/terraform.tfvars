aws_region = "ap-south-1"

project_name = "minimal-3tier"

vpc_cidr = "10.0.0.0/16"

public_subnet_a_cidr = "10.0.1.0/24"
public_subnet_b_cidr = "10.0.2.0/24"

private_subnet_a_cidr = "10.0.11.0/24"
private_subnet_b_cidr = "10.0.12.0/24"

db_name     = "productsdb"
db_username = "admin"

frontend_image = "nginx:latest"
backend_image  = "nginx:latest"