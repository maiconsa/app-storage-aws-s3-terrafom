resource "aws_ecs_cluster" "cluster" {
  name = "${var.app_name}-cluster-${var.env}"
}

resource "aws_ecs_cluster_capacity_providers" "cap_providers" {
  cluster_name       = aws_ecs_cluster.cluster.name
  capacity_providers = ["FARGATE"]
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.app_name}-ecsTaskExecutionRole-${var.env}"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.app_name}-task-def-${var.env}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = "${var.container_name}-${var.env}"
      image     = "${var.container_image}:latest"
      essential = true
      portMappings = [
        {
          protocol = "tcp"
          containerPort = "${var.container_port}"
          hostPort      = 80
        }
      ]
  }, ])
}



resource "aws_security_group" "ecs_task_app_storage" {
  name   = "${var.app_name}-sg-${var.env}"
  vpc_id = var.vpc_id
  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = var.container_port
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}




resource "aws_ecs_service" "app-storage" {
  name            = "${var.app_name}-ecs-service-${var.env}"
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1

  network_configuration {
    subnets          = var.private_subnet_ids
    assign_public_ip = false
    security_groups  = [aws_security_group.ecs_task_app_storage.id]
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_port   = var.container_port
    container_name   = "${var.container_name}-${var.env}"
  }

}
