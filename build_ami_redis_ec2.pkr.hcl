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
    destination = "playbooks"
  }

  provisioner "shell" {
    script = "./install-ansible.sh"
  }

  provisioner "ansible" {
    extra_arguments     = [
      "--ssh-extra-args", "'-o PubkeyAcceptedKeyTypes=+ssh-rsa -o HostkeyAlgorithms=+ssh-rsa'"
    ]
  
    playbook_file = "playbooks/playbook.yml"
  }

}

