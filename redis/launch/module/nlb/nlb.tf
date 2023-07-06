
resource "aws_lb" "nlb" {
  name = "nlb-redis-cluster-devops"
  internal = false
  load_balancer_type = "network"
  subnets = var.get_vpc_subnets
  
}

resource "aws_lb_target_group" "redis-6379" {
  name     = "tg-redis-6379"
  port     = 6379
  protocol = "TCP"
  target_type      = "instance"
  vpc_id   = var.get_vpc_id
      
  health_check {
    enabled             = true
    interval            = 30
    port                = 6379
    protocol            = "TCP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
  }     

}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port = "6379"
  protocol = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.redis-6379.id
    type             = "forward"
  }
}
