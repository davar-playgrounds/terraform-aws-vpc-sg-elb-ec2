output "elb_dns_name" {
      value = "${aws_elb.load_balancing.dns_name}"
}

output "instance_public_ip" {
      value = "${aws_instance.my_instances.*.public_ip}"
}
