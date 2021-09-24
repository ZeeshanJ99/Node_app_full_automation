provider "aws" {
    region = "eu-west-1"
}

resource "aws_security_group" "sre_security_group_grafana"  {
  name = "sre_security_group_grafana_id"
  description = "sre_security_group_grafana_id"
  vpc_id = var.vpc_id # attaching the SG with your own VPC
  ingress {
    from_port       = "80"
    to_port         = "80"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]   
  }
  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
    ingress {
    from_port       = "3000"
    to_port         = "3000"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]  
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1" # allow all
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sre_security_group_grafana"
  }
}

resource "aws_instance" "sre_grafana_terraform" {
  ami =  var.ami_grafana_id
  subnet_id = var.subnet_public_id
  vpc_security_group_ids = [aws_security_group.sre_security_group_grafana_id.id]
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = var.aws_key_name
  connection {
		type = "ssh"
		user = "ubuntu"
		private_key = var.aws_key_path
		host = "${self.associate_public_ip_address}"
	}
  tags = {
      Name = "sre_grafana_terraform"
  }
}