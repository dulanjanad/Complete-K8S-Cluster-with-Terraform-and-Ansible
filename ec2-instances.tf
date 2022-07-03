resource "aws_instance" "worker_nodes" {

  count = var.worker_nodes_count

  ami                    = var.ubuntu_ami
  instance_type          = var.worker_node_instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_traffice.id]
  subnet_id              = module.vpc.private_subnets[0]

  tags = {
    "Name"        = "worker-node-${count.index}.example.com"
    "Environment" = "Dev"
  }

}

resource "aws_instance" "control_node" {

  ami                    = var.ubuntu_ami
  instance_type          = var.control_node_instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_traffice.id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    "Name"        = "control-node.example.com"
    "Environment" = "Dev"
  }

  provisioner "file" {
    source      = "inventory"
    destination = "/home/ubuntu/inventory"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_instance.control_node.public_ip
      private_key = file("./id_rsa")
      agent       = false
    }
  }

  provisioner "file" {
    source      = "id_rsa"
    destination = "/home/ubuntu/.ssh/id_rsa"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_instance.control_node.public_ip
      private_key = file("./id_rsa")
      agent       = false
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chown -R ubuntu.ubuntu /home/ubuntu/",
      "sudo chmod 600 /home/ubuntu/.ssh/id_rsa",
      "sudo apt update",
      "sudo apt -y install ansible",
      "git clone https://github.com/dulanjanad/Configure-K8S-Cluster-with-Ansible.git",
      "cp /home/ubuntu/inventory /home/ubuntu/Configure-K8S-Cluster-with-Ansible/inventory",
      "cd /home/ubuntu/Configure-K8S-Cluster-with-Ansible",
      "ansible-playbook /home/ubuntu/Configure-K8S-Cluster-with-Ansible/set-kubernetes-env.yml -i /home/ubuntu/Configure-K8S-Cluster-with-Ansible/inventory",
      "ansible-playbook /home/ubuntu/Configure-K8S-Cluster-with-Ansible/initialize-kubernetes-cluster.yml -i /home/ubuntu/Configure-K8S-Cluster-with-Ansible/inventory",
      "ansible-playbook /home/ubuntu/Configure-K8S-Cluster-with-Ansible/join-workers.yml -i /home/ubuntu/Configure-K8S-Cluster-with-Ansible/inventory"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_instance.control_node.public_ip
      private_key = file("./id_rsa")
    }

  }

}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCg1QTIxijml7KzTTZn6UGC0E2VfmjqqkDkZrl1zQ7PSeYNPGPK2P2h1vRjqtmKkIHfVA6G/7qq0QMfSKf0DC8Lq87YeXCwtsknL+s2MD22sGtpBGARtN1DFIs6Ao9BfQxkpzd2T7bEgGAdUrsvdVmX0DFO4Hr176ujP4Jl7G5ro2fn2Awa3DHRlEfm09DcSD2sYjaOyj/iIhVVaOk82Y+Uw1P+x6boB5wHf8u5eU9gBGdRgiW91FnZxrlrsZkaQKVjnQdlh3xGIk/aCafDD0dPRE8RXR+1Zkry6/yU9OBZwW9yHJJ2WOooNFVIiBupIVQ2agnbw09Vxfid4HfNl1Xx ubuntu-key"
}