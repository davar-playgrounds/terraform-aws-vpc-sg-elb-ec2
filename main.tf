provider "aws" {
  region = "us-west-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "${var.own_ssh_key}"
}

resource "aws_vpc" "squad_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "squad_gw" {
  vpc_id = "${aws_vpc.squad_vpc.id}"

  tags = {
    Name = "${var.username}-internet_gateway"
  }
}


resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.squad_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.squad_gw.id}"

}

resource "aws_subnet" "squad_subnet" {
  vpc_id     = "${aws_vpc.squad_vpc.id}"
  cidr_block = "${var.subnet_block}"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.username}-subnet"
  }
}


resource "aws_instance" "my_instances" {
  ami = "ami-09fc502e5bed86555"
  count = 6
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.squad_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.sg-instance.id}"]
  associate_public_ip_address = "true"
  key_name = "${aws_key_pair.deployer.id}"

  connection {
    type     = "ssh"
    user     = "ubuntu"
    host = "${self.public_ip}"
    private_key = file("${var.own_ssh_key_path}")
}

  provisioner "remote-exec" {
    inline = [
      "sudo ln -s /usr/bin/python3 /usr/bin/python",
    ]
}

  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu -i '${self.public_ip},' --ssh-common-args='-o StrictHostKeyChecking=no' --private-key ${var.own_ssh_key_path} provision.yml"
}

  tags = {
    Name = "HelloWorld-${count.index}-${var.username}-instance"
  }
}

resource "aws_security_group" "sg-instance" {
  name = "${var.username}-sg-instance"
  vpc_id = "${aws_vpc.squad_vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.username}-sg-instance"
  }
}

resource "aws_elb" "load_balancing" {
  name               = "terraform-elb-http"
  security_groups    = ["${aws_security_group.elb.id}"]
  subnets = ["${aws_subnet.squad_subnet.id}"]

  listener {
    lb_port           = "${var.server_port}"
    lb_protocol       = "http"
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 5
    target              = "HTTP:80/"
  }

  instances                   = [for o in aws_instance.my_instances: "${o.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.username}-elb"
  }
}

resource "aws_security_group" "elb" {
  name = "${var.username}-elb"
  vpc_id = "${aws_vpc.squad_vpc.id}"

ingress {
  from_port = "${var.server_port}"
  to_port = "${var.server_port}"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.username}-sg-elb"
  }
}
