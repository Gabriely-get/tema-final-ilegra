packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "amazon_linux" {
  ami_name      = "ami-redis-jt-devops"
  source_ami    = "ami-03c7d01cf4dedc891"
  instance_type = "t2.micro"
  region        = "us-east-1"
  ssh_keypair_name     = "kp-jt-devops-gabriely-willian.pem"
  ssh_private_key_file = "/home/ilegra/Downloads/kp-jt-devops-gabriely-willian.pem"
  tags = {
    Name             = "ami-redis-jt-devops"
    Owner            = "Gabriely-get"
    Project          = "tema-final"
    EC2_ECONOMIZATOR = "TRUE"
    CustomerID       = "ILEGRA"
  }
  ssh_username = "ec2-user"
}

build {

  sources = [
    "source.amazon-ebs.amazon_linux"
  ]

  provisioner "file" {
    source      = "./playbooks"
    destination = "/home"
  }

  provisioner "file" {
    source      = "./inventory"
    destination = "inventory"
  }

  provisioner "shell" {
    script = "./install-ansible.sh"
  }

  provisioner "shell" {
    inline = [
      "cd /home/playbooks",
      "ansible-playbook playbook.yml"
    ]
  }

}

