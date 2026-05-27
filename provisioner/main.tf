provider "aws"{
    region = "us-east-1"
}

variable "cidr" {
    default = "10.0.0.0/16"
}

resource "aws_key_pair" "example" {
    key_name = "mykey"
    public_key = file("C:\\Users\\digvi\\.ssh\\id_rsa.pub")
}

resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr
}

resource "aws_subnet" "sub1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }       
}

resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "webSg" {
    name = "web"
    vpc_id = aws_vpc.myvpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # this is never recommended for production environments, but for demo purposes, we are allowing SSH access from anywhere
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Web-sg"
    }
}

resource "aws_instance" "server" {
    ami = "ami-05cf1e9f73fbad2e2"
    instance_type = "t2.micro"
    key_name = aws_key_pair.example.key_name
    vpc_security_group_ids = [aws_security_group.webSg.id]
    subnet_id = aws_subnet.sub1.id

    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = file("C:\\Users\\digvi\\.ssh\\id_rsa")
        host = self.public_ip
}

    provisioner "file" {
        source = "app.py"
        destination = "/home/ubuntu/app.py"
    }

    provisioner "remote-exec" {
        inline = [
            "echo 'Hello from the remote instance'",
            "sudo apt update -y",
            "sudo apt install python3-pip -y",
            "cd /home/ubuntu",
            "sudo pip3 install flask",
            "sudo python3 app.py &",
        ]
    }
}