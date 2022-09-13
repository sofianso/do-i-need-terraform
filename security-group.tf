
resource "aws_security_group" "app-load-balancer-sg" {
  name        = "Load Balancer SG"
  description = "Allow load balancer inbound traffic on Port 80/443"
  vpc_id      = aws_vpc.sofian-vpc.id


  ingress {
    description      = "HTTP Access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTPS Access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Web Server Security Group"
  }
}


resource "aws_security_group" "ssh-sg" {
  name        = "SSH Access"
  description = "Allow SSH Access on Port 22"
  vpc_id      = aws_vpc.sofian-vpc.id


  ingress {
    description      = "SSH Access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${var.ssh-location}"]
    ipv6_cidr_blocks = ["::/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "SSH Security Group"
  }
}


resource "aws_security_group" "web-server-sg" {
  name        = "Web Server SG"
  description = "Enable HTTP and HTTPS access on Port 80/443 via ALB and SSH access on Port 22 via SSH SG"
  vpc_id      = aws_vpc.sofian-vpc.id

# HTTP Access is only allowed if it's coming from the ALB SG
  ingress {
    description      = "HTTP Access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.app-load-balancer-sg.id}"]
  }
 ingress {
    description      = "HTTPS Access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups = ["${aws_security_group.app-load-balancer-sg.id}"]
  }
   ingress {
    description      = "SSH Access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = ["${aws_security_group.ssh-sg.id}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Web Server Security Group"
  }
}

resource "aws_security_group" "database-sg" {
  name        = "Database SG"
  description = "Enable MYSQL/Aurora access on Port 3306"
  vpc_id      = aws_vpc.sofian-vpc.id

# HTTP Access is only allowed if it's coming from the ALB SG
  ingress {
    description      = "MYSQL/Aurora Access"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.web-server-sg.id}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Database Security Group"
  }
}

