resource "aws_instance" "tomcat" {
  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.medium"
  vpc_security_group_ids = [ "${aws_security_group.from_uswest.id}" ]
  key_name = "${aws_key_pair.mykey.key_name}"
 
#  provisioner "file" {
#    source = "script-centos.sh"
#    destination = "/tmp/script.sh"
#  }
#  provisioner "remote-exec" {
#    inline = [
#      "chmod +x /tmp/script.sh",
#      "sudo /tmp/script.sh"
#    ]
#  }

   provisioner "local-exec" {
     command = "sleep 40 && echo \"[tomcat-servers]\n${aws_instance.tomcat.public_ip} ansible_connection=ssh ansible_ssh_user=ec2-user ansible_ssh_private_key_file=mykey host_key_checking=False\" > inventory &&  ansible-playbook -i inventory ansible-playbooks/tomcat-site.yml "

  }

  connection {
    user = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }
tags {
    Name = "tomcat"
  }

}
output "tomcat_ip" {
    value = "${aws_instance.tomcat.public_ip}"
}
output "tomcat_END_URL" {
    value = "http://${aws_instance.tomcat.public_ip}:8080"
}

