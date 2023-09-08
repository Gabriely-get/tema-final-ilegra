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
      Name             = "ELK"
    }
  }

}

data "aws_default_tags" "current" {}

data "aws_ami" "elk-ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["ami-elk"]
  }

}

resource "aws_launch_template" "elk" {
  name                   = "lt-elk"
  image_id               = data.aws_ami.elk-ami.image_id
  key_name               = var.get_kp
  vpc_security_group_ids = var.get_security_groups
  instance_type          = "t2.medium"

  placement {
    availability_zone = var.get_availability_zones[0]
  }

}

resource "aws_autoscaling_group" "elk" {

  name               = "asg-elk"
  min_size           = 1
  max_size           = 1
  desired_capacity   = 1
  availability_zones = var.get_availability_zones

  launch_template {
    id      = aws_launch_template.elk.id
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
    value               = "node-elk"
    propagate_at_launch = true
  }

}