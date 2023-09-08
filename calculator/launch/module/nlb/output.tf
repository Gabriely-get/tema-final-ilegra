output "tg_group_arn" {
  value = aws_lb_target_group.calculator-8000.arn
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.nlb.dns_name
}

output "target_group" {
  value = aws_lb_target_group.calculator-8000
}