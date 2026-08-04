output "application_url" { value = "http://${aws_lb.demo.dns_name}" }
output "ecs_cluster_name" { value = aws_ecs_cluster.this.name }
output "ecs_service_name" { value = var.deploy_service ? aws_ecs_service.demo[0].name : null }
output "database_endpoint" { value = aws_db_instance.demo.endpoint }
output "database_secret_arn" { value = aws_db_instance.demo.master_user_secret[0].secret_arn }
