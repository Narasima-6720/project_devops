provider "aws" {
  region = "us-east-1"
}

variable "block" {
  default = "10.0.0.0/16"
}

resource "aws_key_pair" "example" {
  key_name   = "terraform-demo-nara"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_vpc" "myvpc" {
  cidr_block = var.block
}

resource "aws_subnet" "mysubnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "mygwt" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "myrt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mygwt.id
  }
}

resource "aws_route_table_association" "rtas" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.myrt.id
}

resource "aws_security_group" "msg" {
  name   = "website"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "myins" {
  ami                    = "ami-04a81a99f5ec58529"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.msg.id]
  subnet_id              = aws_subnet.mysubnet.id

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "app.py"
    destination = "/home/ubuntu/app.py"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",
      "sudo apt-get install -y python3-pip",
      "cd /home/ubuntu",
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",
      "sudo apt-get install -y python3-pip python3-venv",
      "cd /home/ubuntu",
      "python3 -m venv myenv",
      "myenv/bin/pip install flask",
      "nohup myenv/bin/python app.py &"
    ]
  }
}
#execute this commands

#source myenv/bin/activate

#python app.py
#application then runs

