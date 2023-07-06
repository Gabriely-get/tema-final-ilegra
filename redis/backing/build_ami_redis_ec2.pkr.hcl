packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "amazon_linux" {
  ami_name      = "ami-redis-cluster"
  source_ami    = "ami-03c7d01cf4dedc891"
  instance_type = "t2.micro"
  region        = "us-east-1"
  tags = {
    Name             = "ami-redis-cluster"
    Owner            = "Gabriely-get"
    Project          = "tema-final"
    EC2_ECONOMIZATOR = "TRUE"
    CustomerID       = "ILEGRA"
  }
  ssh_username = "ec2-user"
  ssh_keypair_name     = "kp-jt-devops-gabriely-willian"
  ssh_private_key_file = "/home/ilegra/Downloads/kp-jt-devops-gabriely-willian.pem"
}

build {

  sources = [
    "source.amazon-ebs.amazon_linux"
  ]

  provisioner "file" {
    source      = "./redis/backing/playbooks"
    destination = "/home/ec2-user"
  }


  provisioner "shell" {
    script = "./redis/backing/install-ansible.sh"
  }

  provisioner "shell" {
    inline = [
      "cd /home/ec2-user/playbooks",
      "ansible-playbook playbook.yml"
    ]
  }

}

