resource "aws_instance" "lab_two_web_server" {
  count                  = 4
  ami                    = "ami-0f403e3180720dd7e"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  subnet_id              = element(aws_subnet.public_sn.*.id, count.index)
  vpc_security_group_ids = [aws_security_group.lab_two_sg.id]

  user_data = <<-EOF
                #!/bin/bash   
                sudo yum install docker -y
                sudo systemctl start docker
                sudo docker run -d -p 80:80 nginx
                sudo docker run -d -p 8080:8080 nginx
                sudo docker run -d -p 8081:8081 nginx
                EOF
}
output "instance_public_ips" {
  value = aws_instance.lab_two_web_server[*].public_ip
}
