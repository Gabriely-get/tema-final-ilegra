
resource "aws_lb" "nlb" {
  name = "alb-calculator-devops"
  internal = false
  load_balancer_type = "application"
  subnets = var.get_vpc_subnets
  security_groups = var.get_security_groups
}

resource "aws_lb_target_group" "calculator-8000" {
  name     = "tg-calculator-8000"
  port     = 8000
  protocol = "HTTP"
  target_type      = "instance"
  vpc_id   = var.get_vpc_id
      
  health_check {
    enabled             = true
    interval            = 30
    port                = 8000
    path                = "/calc/historic"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
  }     

}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port = "8000"
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.calculator-8000.id
    type             = "forward"
  }
}
