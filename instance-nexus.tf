resource "aws_instance" "nexus" {
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
     command = "sleep 40 && echo \"[nexus-server]\n${aws_instance.nexus.public_ip} ansible_connection=ssh ansible_ssh_user=ec2-user ansible_ssh_private_key_file=mykey host_key_checking=False\" > nexus-inventory &&  ansible-playbook -i nexus-inventory ansible-playbooks/nexus-create.yml "
  }

  connection {
    user = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }
tags {
    Name = "nexus"
  }

}
output "nexus_ip" {
    value = "${aws_instance.nexus.public_ip}"
}
output "nexus_END_URL" {
    value = "http://${aws_instance.nexus.public_ip}:8081"
}
