# terraform-aws-vpc-sg-elb-ec2
Build a simple infrastructure with terraform on AWS : instances EC2 behind Load Balancer with automated updates when scale up or down

3 files are used to build infrastructure:

 - var.tf: include variables than can be changed
 - main.tf: Code for building infrastructure
 - output.tf : values from infrastructure built (EC2 public IP and LB DNS name)
