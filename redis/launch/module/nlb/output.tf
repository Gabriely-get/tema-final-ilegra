output "tg_group_arn" {
  value = aws_lb_target_group.redis-6379.arn
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.nlb.dns_name
}

output "target_group" {
  value = aws_lb_target_group.redis-6379
}