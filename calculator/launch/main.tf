terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Owner            = "Gabriely-get"
      Project          = "tema-final"
      EC2_ECONOMIZATOR = "TRUE"
      CustomerID       = "ILEGRA"
      Name             = "go-calculator"
    }
  }

}

data "aws_default_tags" "current" {}

data "aws_ami" "calculator-ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["ami-go-calculator"]
  }

}

resource "aws_launch_template" "go-calculator" {
  name                   = "lt-go-calculator"
  image_id               = data.aws_ami.calculator-ami.image_id
  key_name               = var.get_kp
  vpc_security_group_ids = var.get_security_groups
  instance_type          = "t2.micro"

  placement {
    availability_zone = var.get_availability_zones[0]
  }

}

resource "aws_autoscaling_group" "go-calculator" {

  name               = "asg-go-calculator"
  min_size           = 2
  max_size           = 3
  desired_capacity   = 2
  availability_zones = var.get_availability_zones

  launch_template {
    id      = aws_launch_template.go-calculator.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = data.aws_default_tags.current.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  tag {
    key                 = "node"
    value               = "node-calculator"
    propagate_at_launch = true
  }

}

module "moduleNLB" {
  source = "./module/nlb"
}

resource "aws_autoscaling_attachment" "asg_main_attachment_nlb" {
  autoscaling_group_name = aws_autoscaling_group.go-calculator.name
  lb_target_group_arn    = module.moduleNLB.tg_group_arn
}

data "aws_instances" "calc_instances" {

  filter {
    name = "tag:Name"
    values = ["go-calculator"]
  }
  
  filter {
    name = "tag:node"
    values = ["node-elk"]
  }

  filter {
    name   = "image-id"
    values = [data.aws_ami.calculator-ami.image_id]
  }


  instance_state_names = ["running", "pending"]
}

locals {
  instances = data.aws_instances.calc_instances.ids
}

resource "aws_lb_target_group_attachment" "target-group-attach" {
  for_each = toset(local.instances)

  target_group_arn = module.moduleNLB.tg_group_arn
  target_id        = each.value
}
