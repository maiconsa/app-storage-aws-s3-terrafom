output "blue_target_group" {
  value = aws_alb_target_group.blue
}

output "green_target_group" {
  value = aws_alb_target_group.green
}



output "test_alb_listener_arn" {
  value = aws_alb_listener.test.arn
}

output "main_alb_listener_arn" {
  value = aws_alb_listener.main.arn
}


output "sec_group_id" {
  value = aws_security_group.alb_security_group.id
}