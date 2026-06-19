resource "aws_vpc" "myvpc" {
    cidr_block           = var.vpc_cidr 

    tags = {
        Name = "${var.environment}-vpc"
    }
  
}

resource "aws_internet_gateway" "myigw" {
    vpc_id = aws_vpc.myvpc.id

    tags = {
        Name = "${var.environment}-igw"
    }
}

resource "aws_subnet" "mysubnet" {
    vpc_id                  = aws_vpc.myvpc.id
    cidr_block              = var.subnet_cidr
    availability_zone       = var.availability_zone
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.environment}-subnet"
    }
}

resource "aws_route_table" "myrt" {
    vpc_id = aws_vpc.myvpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myigw.id
    }

    tags = {
        Name = "${var.environment}-rt"
    }
}

resource "aws_route_table_association" "myrta" {
    subnet_id = aws_subnet.mysubnet.id
    route_table_id = aws_route_table.myrt.id
}

