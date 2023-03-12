resource "aws_ecs_service" "atlantis" {
  name            = var.name
  cluster         = var.create_ecs_cluster ? aws_ecs_cluster.atlantis[0].id : var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.atlantis.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.atlantis.arn
    container_name   = var.name
    container_port   = var.atlantis_port
  }

  network_configuration {
    subnets         = var.network_configuration.private_subnets
    security_groups = [aws_security_group.atlantis_security_group.id]
  }
}
