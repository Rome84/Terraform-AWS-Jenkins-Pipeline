resource "aws_instance" "jenkins" {
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
<<<<<<< HEAD
     command = "sleep 40 && echo \"[jenkins-server]\n${aws_instance.jenkins.public_ip} ansible_connection=ssh ansible_ssh_user=ec2-user ansible_ssh_private_key_file=mykey host_key_checking=False\" > jenkins-inventory &&  ansible-playbook -i jenkins-inventory ansible-playbooks/jenkins-create.yml "

=======
     command = "sleep 30 && echo \"[jenkins-server]\n${aws_instance.jenkins.public_ip} ansible_connection=ssh ansible_ssh_user=ec2-user ansible_ssh_private_key_file=mykey host_key_checking=False\" > jenkins-inventory &&  ansible-playbook -i jenkins-inventory ansible-playbooks/jenkins-create.yml "
>>>>>>> b7a34d87a66468d1c2441c3efb38c6593975a516
  }

  connection {
    user = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }
  #provisioner "local-exec" {
  #   command = "echo ${aws_instance.example.private_ip} >> private_ips.txt"
  #}
tags {
    Name = "jenkins"
  }

}
output "jenkins_ip" {
    value = "${aws_instance.jenkins.public_ip}"
}
output "jenkins_END_URL" {
    value = "http://${aws_instance.jenkins.public_ip}:8080"
}

