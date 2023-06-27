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
      node             = "node-redis"
    }
  }

}

data "aws_default_tags" "current" {}

data "aws_ami" "redis-ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["ami-redis-jt-devops"]
  }

}

resource "aws_launch_template" "redis-cluster" {
  name                   = "lt-redis-cluster"
  image_id               = data.aws_ami.redis-ami.image_id
  key_name               = var.get_kp
  vpc_security_group_ids = var.get_security_groups
  instance_type          = "t2.micro"

  placement {
    availability_zone = var.get_availability_zones[0]
  }

}

resource "aws_autoscaling_group" "redis_main" {

  name               = "asg-redis-main"
  min_size           = 1
  max_size           = 1
  desired_capacity   = 1
  availability_zones = var.get_availability_zones

  launch_template {
    id      = aws_launch_template.redis-cluster.id
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
    key                 = "nodeType"
    value               = "master"
    propagate_at_launch = true
  }

}

resource "aws_autoscaling_group" "redis_replica" {

  name               = "asg-redis-replica"
  min_size           = 1
  max_size           = 2
  desired_capacity   = 1
  availability_zones = var.get_availability_zones

  launch_template {
    id      = aws_launch_template.redis-cluster.id
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
    key                 = "nodeType"
    value               = "replica"
    propagate_at_launch = true
  }

}

module "moduleNLB" {
  source = "./module/nlb"
}

resource "aws_autoscaling_attachment" "asg_main_attachment_nlb" {
  autoscaling_group_name = aws_autoscaling_group.redis_main.name
  lb_target_group_arn    = module.moduleNLB.tg_group_arn
}

resource "aws_autoscaling_attachment" "asg_replica_attachment_nlb" {
  autoscaling_group_name = aws_autoscaling_group.redis_replica.name
  lb_target_group_arn    = module.moduleNLB.tg_group_arn
}



locals {
  instances = data.aws_instances.redis_instances.ids
}

data "aws_instances" "redis_instances" {

  instance_tags = {
    node = "node-redis"
  }

  instance_state_names = ["running", "pending"]
}

resource "aws_lb_target_group_attachment" "target-group-attach" {
  for_each = toset(local.instances)

  target_group_arn = module.moduleNLB.tg_group_arn
  target_id        = each.value
}