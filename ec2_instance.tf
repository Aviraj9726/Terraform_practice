resource "aws_instance" "ec2-test" {
  ami = data.aws_ami.example.id
  #count = length(var.instance_type)
  instance_type = var.instance_type_map["dev"]
  key_name = "kube-demo"
  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install apache2 -y
    sudo systemctl enable apache2
    sudo systemctl start apache2
    echo "<h1>Welcome to  AWS Infra </h1>" > /var/www/html/index.html
    EOF
  vpc_security_group_ids = [aws_security_group.ssh-sg.id]
  for_each = toset(keys({for az,instance in data.aws_ec2_instance_type_offerings.instance_offerings:
  az => instance.instance_types if length(instance.instance_types) != 0}))
 availability_zone = each.key




}


resource "aws_security_group" "ssh-sg" {
  name        = "allow-ssh"
  description = "Allow ssh"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    description = "ssh-port-access"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    description = "ssh-port-access"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Outputs

output "instance_details" {
  description = "list details"
  value = [for i in aws_instance.ec2-test: i.public_ip]
}

output "instance_map" {
  description = "map wise details"
  value = {for i in aws_instance.ec2-test: i.id => i.public_ip}
}
