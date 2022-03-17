

provider "aws" {
  region = "us-east-1"
  access_key = "AKIAXQVTJUOJNR64HE6Q"
  secret_key = "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"
}

# 1. Create VPC
resource "aws_vpc" "wvpc" {
  cidr_block = "10.5.0.0/16"
  tags = {
    Name = "Prod-vpc"
  }
}
# 2. create inernet Gateway
resource "aws_internet_gateway" "wgt" {
    vpc_id = aws_vpc.wvpc.id
  
}
# 3. create Custom Route table
resource "aws_route_table" "wtable" {
    vpc_id = aws_vpc.wvpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.wgt.id
  }

  route {
      ipv6_cidr_block = "::/0"
      gateway_id = aws_internet_gateway.wgt.id
  }
  tags = {
       Name = "Prod"
  }
}
# 4. create a Subnet
resource "aws_subnet" "wsubnet" {
    vpc_id = aws_vpc.wvpc.id
    cidr_block = "10.5.0.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name ="Prod-Subnet"
    }
}
# 5. Associate subnet with Route Table
resource "aws_route_table_association" "was" {
  subnet_id = aws_subnet.wsubnet.id
  route_table_id = aws_route_table.wtable.id
}
# 6. create Security Group to allow port 22,80,443
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.wvpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}
# 7. create a network interface with an ip in the subnet that was created in step4

resource "aws_network_interface" "web_nic" {
  subnet_id       = aws_subnet.wsubnet.id
  private_ips     = ["10.5.0.50"]
  security_groups = [aws_security_group.allow_web.id]

}

# 8. Assigne an elastic Ip to the network interface created in step7
resource "aws_eip" "one" {
  vpc     = true
  network_interface  = aws_network_interface.web_nic.id
  associate_with_private_ip = "10.5.0.50"
  depends_on = [aws_internet_gateway.wgt]
    
}

output "server_public_ip" {
  value = aws_eip.one.public_ip
}
# 9. create ubuntu server and install/enable apache2

resource "aws_instance" "web-server" {
  ami = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "mykp"
  
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web_nic.id
  }
 
 user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo your very first web server > var/www/html/index.html'
              EOF
 tags = {
   Name = "web-server"
 }

}    
