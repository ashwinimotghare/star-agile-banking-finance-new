resource "aws_instance" "test-server" {
  ami = "ami-0583d8c7a9c35822c"
  instance_type = "t2.micro"
  key_name = "banking"
  vpc_security_group_ids = ["sg-04c4656a45ae98952"]
  connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./banking.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansiblePlaybook credentialsId: 'terraform-ansible', disableHostKeyChecking: true, installation: 'ansible', inventory: 'inventory', playbook: 'ansibleplaybook.yml', vaultTmpPath:"
     }
  }
